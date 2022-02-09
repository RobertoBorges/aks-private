resource "azurerm_log_analytics_workspace" "loganalytics" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = var.resource_group
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "loganalytics" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.loganalytics.location
    resource_group_name   = var.resource_group
    workspace_resource_id = azurerm_log_analytics_workspace.loganalytics.id
    workspace_name        = azurerm_log_analytics_workspace.loganalytics.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}
resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}
