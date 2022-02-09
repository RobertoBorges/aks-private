variable vnet_kube_name {
  description = "VNET name Kubernetes "
  type        = string
}

variable vnet_kube_id {
  description = "VNET ID Kubernetes "
  type        = string
}

variable vnet_kube_rg {
  description = "VNET resource group Kubernetes "
  type        = string
}

variable vnet_corp_name {
  description = "VNET name corporate-network "
  type        = string
}

variable vnet_corp_id {
  description = "VNET ID corporate-network"
  type        = string
}

variable vnet_corp_rg {
  description = "VNET resource group corporate-network "
  type        = string
}

variable peering_name_kube_to_corp {
  description = "Name peering kube to corp "
  type        = string
  default     = "peeringkubetocorp"
}

variable peering_name_corp_to_kube {
  description = "Name peering corp to kube"
  type        = string
  default     = "peeringcorptokube"
}