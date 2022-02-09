variable resource_group {
  description = "Resource group name"
  type        = string
}

variable log_analytics_workspace_name {
    description = "Workspace name for Log analytics"
    type        = string
    default = "privateLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
  description = "Location where Log analytic will be deployed"
  type        = string
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    description = "SKU for Log analytic"
    type        = string
    default = "PerGB2018"
}
