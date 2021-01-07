provider "azurerm" {
  features {}
}

resource "random_string" "storage-acc-name" {
  length = 12
  lower = true
  upper = false
  special = false
}

resource "azurerm_resource_group" "rg-bad-storage-acc" {
  location = "East US"
  name = "RG_bad_storage_acc"
}

resource "azurerm_storage_account" "bad-storage-acc" {
  name                     = "badstor${random_string.storage-acc-name.result}"
  resource_group_name      = azurerm_resource_group.rg-bad-storage-acc.name
  location                 = azurerm_resource_group.rg-bad-storage-acc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
