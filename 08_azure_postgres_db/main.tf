provider "azurerm" {}

resource "azurerm_resource_group" "dev" {
  name     = "${var.resource_group_name}-${uuid()}"
  location = "West Europe"
}

resource "azurerm_postgresql_server" "dev" {
  name                = "postgresql-server-1-${uuid()}"
  location            = "${azurerm_resource_group.dev.location}"
  resource_group_name = "${azurerm_resource_group.dev.name}"

  sku {
    name = "B_Gen4_2"
    capacity = 2
    tier = "Basic"
    family = "Gen4"
  }

  storage_profile {
    storage_mb = 5120
    backup_retention_days = 7
    geo_redundant_backup = "Disabled"
  }

  administrator_login = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version = "9.5"
  ssl_enforcement = "Enabled"
}

resource "azurerm_postgresql_database" "dev" {
  name                = "exampledb"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  server_name         = "${azurerm_postgresql_server.dev.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}