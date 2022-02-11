resource "azurerm_private_dns_zone" "zone" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.linked_vnets

  name                  = format("%s-link", each.key)
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zone.name
  virtual_network_id    = each.value
  registration_enabled  = var.registration_enabled
  tags                  = var.tags
}

resource "azurerm_private_dns_a_record" "a_records" {
  for_each = var.a_records
  
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = var.tags
}

resource "azurerm_private_dns_aaaa_record" "aaaa_records" {
  for_each = var.aaaa_records
  
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = var.tags
}

resource "azurerm_private_dns_cname_record" "cname_records" {
  for_each = var.cname_records
  
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl
  record              = each.value.record
  tags                = var.tags
}

resource "azurerm_private_dns_mx_record" "mx_records" {
  for_each = var.mx_records

  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = { for i, r in each.value.records : i => r }
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }

  tags = var.tags
}

resource "azurerm_private_dns_ptr_record" "ptr_records" {
  for_each = var.ptr_records
  
  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = var.tags
}

resource "azurerm_private_dns_srv_record" "srv_records" {
  for_each = var.srv_records

  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = { for i, r in each.value.records : i => r }
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }

  tags = var.tags
}

resource "azurerm_private_dns_txt_record" "txt_records" {
  for_each = var.txt_records

  name                = each.key
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.zone.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = { for i, r in each.value.records : i => r }
    content {
      value   = record.value.value
    }
  }

  tags = var.tags
}