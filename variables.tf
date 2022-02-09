variable "vnet_resource_group_name" {
  description = "The resource group name to be created"
  default     = "corpnetworks-rg"
}

variable "tags_environment_name" {
  description = "Environment name"
  default     = "Production"
}

variable "kube_resource_group_name" {
  description = "The resource group name to be created"
  default     = "secureaks-rg"
}

variable "location" {
  description = "The resource group location"
  default     = "eastus2"
}

variable "aks_version" {
  description = "Version of AKS"
  default     = "1.22.4"
}

variable "hub_vnet_name" {
  description = "Hub VNET name"
  default     = "hubcorp-firewallvnet"
}

variable "kube_vnet_name" {
  description = "AKS VNET name"
  default     = "spokekube-kubevnet"
}

variable "nodepool_nodes_count" {
  description = "Default nodepool nodes count"
  default     = 1
}

variable "nodepool_vm_size" {
  description = "Default nodepool VM size"
  default     = "Standard_DS3_v2"
}

variable "nodepool_auto_scaling_min_count" {
  description = "Min number of VMs in the scaleset"
  default     = "1"
}

variable "nodepool_auto_scaling_max_count" {
  description = "Max number of VMs in the scaleset"
  default     = "5"
}

variable "nodepool_max_pod" {
  description = "Maximum number of PODs per nod"
  default     = "200"
}

variable "network_docker_bridge_cidr" {
  description = "CNI Docker bridge cidr"
  default     = "172.17.0.1/16"
}

variable "network_dns_service_ip" {
  description = "CNI DNS service IP"
  default     = "10.2.0.10"
}

variable "network_service_cidr" {
  description = "CNI service cidr"
  default     = "10.2.0.0/24"
}

variable "log_analytics_workspace_name" {
  default = "PoCLogAnalyticsWorkspaceNamerbb"
}
# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable "log_analytics_workspace_location" {
  default = "eastus2"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "dns_fw_name" {
  default = "pocsecureaksrbb"
}

variable "ingress_nginx" {
  description = "IP Address for our internal LBL inside AKS"
  default     = "10.0.8.207"
}

variable "private_acr" {
  description = "Name of the private Azure Container Registry"
  default     = "pocacraksrbb"
}

variable "fw_name" {
  description = "Name of the firewall"
  default     = "kubenetfwrbb"
}
