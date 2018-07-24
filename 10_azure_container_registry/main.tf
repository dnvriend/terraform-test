provider "azurerm" {}

resource "azurerm_resource_group" "test" {
  name     = "dnvriend-container-registry"
  location = "West Europe"
}

resource "azurerm_storage_account" "test" {
  name                     = "dnvriendstorageaccount"
  resource_group_name      = "${azurerm_resource_group.test.name}"
  location                 = "${azurerm_resource_group.test.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_container_registry" "test" {
  name                = "dnvriendcontainerregistry"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${azurerm_resource_group.test.location}"
  admin_enabled       = true
  sku                 = "Classic"
  storage_account_id  = "${azurerm_storage_account.test.id}"
}
