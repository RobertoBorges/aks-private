output "name" {
    value = var.name
}

output "id" {
    value = azurerm_private_dns_zone.zone.id
}

output "number_of_record_sets" {
    value = azurerm_private_dns_zone.zone.number_of_record_sets
}

output "max_number_of_record_sets" {
    value = azurerm_private_dns_zone.zone.max_number_of_record_sets
}

output "max_number_of_virtual_network_links" {
    value = azurerm_private_dns_zone.zone.max_number_of_virtual_network_links
}

output "max_number_of_virtual_network_links_with_registration" {
    value = azurerm_private_dns_zone.zone.max_number_of_virtual_network_links_with_registration
}

output "vnet_links_ids" {
    value = azurerm_private_dns_zone_virtual_network_link.vnet_links
}

output "a_records" {
    value = azurerm_private_dns_a_record.a_records
}

output "aaaa_records" {
    value = azurerm_private_dns_aaaa_record.aaaa_records
}

output "cname_records" {
    value = azurerm_private_dns_cname_record.cname_records
}

output "mx_records" {
    value = azurerm_private_dns_mx_record.mx_records
}

output "ptr_records" {
    value = azurerm_private_dns_ptr_record.ptr_records
}

output "srv_records" {
    value = azurerm_private_dns_srv_record.srv_records
}

output "txt_records" {
    value = azurerm_private_dns_txt_record.txt_records
}