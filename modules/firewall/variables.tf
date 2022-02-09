variable resource_group {
  description = "Resource group name"
  type        = string
}

variable location {
  description = "Location where Firewall will be deployed"
  type        = string
}

variable pip_name {
  description = "Firewal public IP name"
  type        = string
  default     = "azure-fw-ip"
}

variable fw_name {
  description = "Firewal name"
  type        = string
}

variable subnet_id {
  description = "Subnet ID"
  type        = string
}

variable dns_fw_name {
  description = "Mane of the DNS for the Public IP of the Firewall"
  type        = string
}

variable "ingress_nginx" {
  description = "IP Address for our internal LBL inside AKS"
  type        = string
}
