resource "azurerm_virtual_network_peering" "peering" {
  name                      = var.peering_name_kube_to_corp
  resource_group_name       = var.vnet_kube_rg
  virtual_network_name      = var.vnet_kube_name
  remote_virtual_network_id = var.vnet_corp_id
}

resource "azurerm_virtual_network_peering" "peering-back" {
  name                      = var.peering_name_corp_to_kube
  resource_group_name       = var.vnet_corp_rg
  virtual_network_name      = var.vnet_corp_name
  remote_virtual_network_id = var.vnet_kube_id
}