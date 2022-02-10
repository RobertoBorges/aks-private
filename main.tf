terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  backend "azurerm" {
    resource_group_name  = "infrapfeborges-rg"
    storage_account_name = "storagepfeborges"
    container_name       = "terraformdev"
    key                  = "production-terraform.state"
  }  

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnet" {
  name     = var.vnet_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "kube" {
  name     = var.kube_resource_group_name
  location = var.location
}

module "hub_network" {
  source                                          = "./modules/vnet"
  resource_group_name                             = azurerm_resource_group.vnet.name
  location                                        = var.location
  vnet_name                                       = var.hub_vnet_name
  address_space                                   = ["10.0.0.0/22"]
  enforce_private_link_endpoint_network_policies  = false
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : ["10.0.0.0/24"]
    },
    {
      name : "jumpbox-subnet"
      address_prefixes : ["10.0.1.0/24"]
    }
  ]
}

module "kube_network" {
  source                                          = "./modules/vnet"
  resource_group_name                             = azurerm_resource_group.kube.name
  location                                        = var.location
  vnet_name                                       = var.kube_vnet_name
  address_space                                   = ["10.0.8.0/21"]
  enforce_private_link_endpoint_network_policies  = true
  subnets = [
    {
      name : "aks-subnet"
      address_prefixes : ["10.0.8.0/22"]
    }
  ]
}

module "vnet_peering" {
  source                    = "./modules/vnet_peering"
  vnet_kube_name            = var.hub_vnet_name
  vnet_kube_id              = module.hub_network.vnet_id
  vnet_kube_rg              = azurerm_resource_group.vnet.name
  vnet_corp_name            = var.kube_vnet_name
  vnet_corp_id              = module.kube_network.vnet_id
  vnet_corp_rg              = azurerm_resource_group.kube.name
  peering_name_kube_to_corp = "HubToSpokeCorpToKube"
  peering_name_corp_to_kube = "SpokeToHubKubeToCorp"
}

module "firewall" {
  source         = "./modules/firewall"
  resource_group = azurerm_resource_group.vnet.name
  location       = var.location
  pip_name       = "azureFirewalls-ip"
  fw_name        = var.fw_name
  subnet_id      = module.hub_network.subnet_ids["AzureFirewallSubnet"]
  dns_fw_name    = var.dns_fw_name
  ingress_nginx  = var.ingress_nginx
}

module "routetable" {
  source             = "./modules/route_table"
  resource_group     = azurerm_resource_group.vnet.name
  location           = var.location
  rt_name            = "kubenetfw_fw_rt"
  r_name             = "kubenetfw_fw_r"
  firewal_private_ip = module.firewall.fw_private_ip
  subnet_id          = module.kube_network.subnet_ids["aks-subnet"]
}

module "log_analytics" {
  source                           = "./modules/log_analytics"
  resource_group                   = azurerm_resource_group.vnet.name
  log_analytics_workspace_location = var.log_analytics_workspace_location
  log_analytics_workspace_name     = var.log_analytics_workspace_name
  log_analytics_workspace_sku      = var.log_analytics_workspace_sku
}

resource "azurerm_kubernetes_cluster" "privateaks" {
  name                    = "private-aks"
  location                = var.location
  kubernetes_version      = var.aks_version
  resource_group_name     = azurerm_resource_group.kube.name
  dns_prefix              = "private-aks"
  private_cluster_enabled = true

  default_node_pool {
    name                = "default"
    node_count          = var.nodepool_nodes_count
    vm_size             = var.nodepool_vm_size
    vnet_subnet_id      = module.kube_network.subnet_ids["aks-subnet"]
    max_pods            = var.nodepool_max_pod
    enable_auto_scaling = true
    min_count           = var.nodepool_auto_scaling_min_count
    max_count           = var.nodepool_auto_scaling_max_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    docker_bridge_cidr = var.network_docker_bridge_cidr
    dns_service_ip     = var.network_dns_service_ip
    network_plugin     = "azure"
    network_policy     = "calico"
    outbound_type      = "userDefinedRouting"
    service_cidr       = var.network_service_cidr
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = module.log_analytics.log_analytics_workspace_id
    }

    aci_connector_linux {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }
  }

  tags = {
    Environment = var.tags_environment_name
  }

  depends_on = [module.routetable, module.log_analytics]
}

resource "azurerm_container_registry" "acr" {
  name                          = var.private_acr
  resource_group_name           = azurerm_resource_group.vnet.name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "acr-endpoint" {
  name                = "acrpocrbb-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet.name
  subnet_id           = module.hub_network.subnet_ids["AzureFirewallSubnet"]

  private_service_connection {
    name                           = "acrpocaks-privateserviceconnection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = [ "registry" ]
    is_manual_connection           = false
  }
}


# If needed we can add  Aditional  NodePools  and a different configuration
# resource "azurerm_kubernetes_cluster_node_pool" "nodepool2" {
#   name                  = "internal"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.privateaks.id
#   vm_size               = var.nodepool_vm_size
#   node_count            = var.nodepool_nodes_count
#   max_pods              = var.nodepool_max_pod
#   enable_auto_scaling   = true
#   min_count             = var.nodepool_auto_scaling_min_count
#   max_count             = var.nodepool_auto_scaling_max_count
#   tags = {
#     Environment = var.tags_environment_name
#   }
# }

## This Role Contributor is 
## Necessary due to this BUG:
## https://github.com/Azure/AKS/issues/1557
## Adictionnly, the Principal Service Name, 
## need to be Owner of the subscription
resource "azurerm_role_assignment" "vmcontributor" {
  role_definition_name = "Virtual Machine Contributor"
  scope                = azurerm_resource_group.vnet.id
  principal_id         = azurerm_kubernetes_cluster.privateaks.identity[0].principal_id
}

resource "azurerm_role_assignment" "akscontributor" {
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.kube.id
  principal_id         = azurerm_kubernetes_cluster.privateaks.identity[0].principal_id
}

module "jumpbox" {
  source                  = "./modules/jumpbox"
  location                = var.location
  resource_group          = azurerm_resource_group.vnet.name
  vnet_id                 = module.hub_network.vnet_id
  subnet_id               = module.hub_network.subnet_ids["jumpbox-subnet"]
  dns_zone_name           = join(".", slice(split(".", azurerm_kubernetes_cluster.privateaks.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.privateaks.private_fqdn))))
  dns_zone_resource_group = azurerm_kubernetes_cluster.privateaks.node_resource_group
}

resource "azurerm_role_assignment" "aksacrpull" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
  principal_id         = azurerm_kubernetes_cluster.privateaks.identity[0].principal_id
}

resource "azurerm_role_assignment" "akspoolacrpull" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
  principal_id         = azurerm_kubernetes_cluster.privateaks.kubelet_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.privateaks]

}