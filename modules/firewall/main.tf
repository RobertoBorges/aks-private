resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.dns_fw_name
}

resource "azurerm_firewall" "fw" {
  name                = var.fw_name
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                 = "fw_ip_config"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "time" {
  name                = "time"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 101
  action              = "Allow"

  rule {
    description           = "aks node time sync rule"
    name                  = "allow network"
    source_addresses      = ["*"]
    destination_ports     = ["123"]
    destination_addresses = ["*"]
    protocols             = ["UDP"]
  }
}

resource "azurerm_firewall_network_rule_collection" "dns" {
  name                = "dns"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 102
  action              = "Allow"

  rule {
    description           = "aks node dns rule"
    name                  = "allow network"
    source_addresses      = ["*"]
    destination_ports     = ["53"]
    destination_addresses = ["*"]
    protocols             = ["UDP"]
  }
}

resource "azurerm_firewall_network_rule_collection" "servicetags" {
  name                = "servicetags"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 110
  action              = "Allow"

  rule {
    description       = "allow service tags"
    name              = "allow service tags"
    source_addresses  = ["*"]
    destination_ports = ["*"]
    protocols         = ["Any"]

    destination_addresses = [
      "AzureContainerRegistry",
      "MicrosoftContainerRegistry",
      "AzureActiveDirectory"
    ]
  }
}

resource "azurerm_firewall_application_rule_collection" "aksbasics" {
  name                = "aksbasics"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 101
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
      "*.cdn.mscr.io",
      "dev.azure.com",
      "*.dev.azure.com",
      "mcr.microsoft.com",
      "management.core.windows.net",
      "*.data.mcr.microsoft.com",
      "management.azure.com",
      "login.microsoftonline.com",
      "acs-mirror.azureedge.net",
      "dc.services.visualstudio.com",
      "*.opinsights.azure.com",
      "*.ods.opinsights.azure.com",
      "*.oms.opinsights.azure.com",
      "*.microsoftonline.com",
      "*.monitoring.azure.com",
      "*.gcr.io",
      "us.gcr.io",
      "mirror.gcr.io",
      "gcr.io",
      "*.cloud.google.com",
      "cloud.google.com",
      "poctcprivateacr.azurecr.io",
      "quay.io",
      "*.quay.io",
      "acme-staging.api.letsencrypt.org",
      "acme-staging-v02.api.letsencrypt.org",
      "*.letsencrypt.org",
      "letsencrypt.org",       
      "*.blob.core.windows.net"
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "osupdates" {
  name                = "osupdates"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 102
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
      "download.opensuse.org",
      "security.ubuntu.com",
      "ntp.ubuntu.com",
      "packages.microsoft.com",
      "snapcraft.io"
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "publicimages" {
  name                = "publicimages"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 103
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
      "auth.docker.io",
      "registry-1.docker.io",
      "production.cloudflare.docker.com",
      "gcr.io",
      "k8s.gcr.io"
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "test" {
  name                = "test"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 104
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
      "*.bing.com"
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "webbasics" {
  name                = "webbasics"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 105
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
      "*.bootstrapcdn.com",
      "*.googleapis.com",
      "*.dev.azure.com",
      "*.cloudflare.com"
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "OMS" {
  name                = "OMS"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 120
  action              = "Allow"

  rule {
    description           = "Azure Monitor ports"
    name                  = "allow network"
    source_addresses      = ["*"]
    destination_ports     = ["25226"]
    destination_addresses = ["*"]
    protocols             = ["TCP"]
  }
}

resource "azurerm_firewall_network_rule_collection" "NGINX" {
  name                = "NGINXRule"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 130
  action              = "Allow"

  rule {
    description           = "Allow Nginx routing"
    name                  = "allow network"
    source_addresses      = ["*"]
    destination_ports     = ["8443"]
    destination_addresses = ["*"]
    protocols             = ["TCP"]
  }
}

resource "azurerm_firewall_nat_rule_collection" "external" {
  name                = "ingresConnection"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group
  priority            = 100
  action              = "Dnat"

  rule {
    name = "ingressAllowHttps"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "443"
    ]

    destination_addresses = [
      azurerm_public_ip.pip.ip_address
    ]

    translated_port = 443

    translated_address = var.ingress_nginx

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "ingressAllowHttp"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80"
    ]

    destination_addresses = [
      azurerm_public_ip.pip.ip_address
    ]

    translated_port = 80

    translated_address = var.ingress_nginx

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "ingressAllowHttp8080"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "8080"
    ]

    destination_addresses = [
      azurerm_public_ip.pip.ip_address
    ]

    translated_port = 8080

    translated_address = var.ingress_nginx

    protocols = [
      "TCP",
    ]
  }

}
