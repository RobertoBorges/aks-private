variable resource_group {
  description = "Resource group where RouteTable will be deployed"
  type        = string
}

variable location {
  description = "Location where RouteTable will be deployed"
  type        = string
}

variable rt_name {
  description = "RouteTable name"
  type        = string
}

variable r_name {
  description = "AKS route name"
  type        = string
}

variable firewal_private_ip {
  description = "Firewall private IP"
  type        = string
}

variable subnets {
  description = "AKS subnet ID"
}
// variable subnets {
//   description = "AKS subnet ID"
//   type = list(string)
// }