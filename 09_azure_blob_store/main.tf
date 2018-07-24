provider "azurerm" {}

resource "azurerm_resource_group" "dev" {
  name     = "dnvriend-blob-store-${uuid()}"
  location = "West Europe"
}

resource "azurerm_storage_account" "dev" {
  name                     = "dnvriend-storage-account-${uuid()}"
  resource_group_name      = "${azurerm_resource_group.dev.name}"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "dev" {
  name                  = "dnvriend-storage-container-${uuid()}"
  resource_group_name   = "${azurerm_resource_group.dev.name}"
  storage_account_name  = "${azurerm_storage_account.dev.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "testsb" {
  name = "dnvriend-storage-blob-${uuid()}"

  resource_group_name    = "${azurerm_resource_group.dev.name}"
  storage_account_name   = "${azurerm_storage_account.dev.name}"
  storage_container_name = "${azurerm_storage_container.dev.name}"

  type = "page"
  size = 5120
}