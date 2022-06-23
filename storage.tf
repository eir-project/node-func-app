resource "azurerm_storage_account" "func_storage" {
  name                      = "st${var.project}${var.app}${var.environment}"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
}