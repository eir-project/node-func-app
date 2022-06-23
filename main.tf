resource "azurerm_app_service_plan" "func_host" {
  name                = "plan-${var.project}-${var.app}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.func_location
  kind                = "FunctionApp"

  sku {
    tier     = "Dynamic"
    size     = "Y1"
    capacity = 0
  }

  reserved                     = true
  maximum_elastic_worker_count = 1

}

locals {
  app_settings = merge({
    FUNCTIONS_WORKER_RUNTIME                 = "node"
    SCM_DO_BUILD_DURING_DEPLOYMENT           = "false"
    ENABLE_ORYX_BUILD                        = false
    WEBSITE_NODE_DEFAULT_VERSION             = "node|16"
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = azurerm_storage_account.func_storage.primary_connection_string
    WEBSITE_CONTENTSHARE                     = "${var.project}${var.app}${var.environment}"

  }, var.app_settings)
}


resource "azurerm_function_app" "func" {
  name                       = "fn-${var.project}-${var.app}-${var.environment}"
  os_type                    = "linux"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.func_location
  app_service_plan_id        = azurerm_app_service_plan.func_host.id
  storage_account_name       = azurerm_storage_account.func_storage.name
  storage_account_access_key = azurerm_storage_account.func_storage.primary_access_key
  version                    = "~4"
  app_settings               = local.app_settings
  site_config {
    linux_fx_version = "node|16"
  }
  lifecycle {
    ignore_changes = [
      "client_cert_mode",
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}
