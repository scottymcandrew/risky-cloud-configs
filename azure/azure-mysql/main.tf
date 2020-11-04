provider "azurerm" {
  features {}
}

resource "random_string" "storage-acc-name" {
  length = 12
  lower = true
  upper = false
  special = false
}

resource "azurerm_resource_group" "rg-sql" {
  location = "East US"
  name = "RG_BadSQL_TF"
}

resource "azurerm_virtual_network" "vnet-sql" {
  name                = "vnet-sql"
  resource_group_name = azurerm_resource_group.rg-sql.name
  location            = azurerm_resource_group.rg-sql.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_storage_account" "storage-sql" {
  name                     = "${random_string.storage-acc-name.result}storagesql"
  resource_group_name      = azurerm_resource_group.rg-sql.name
  location                 = azurerm_resource_group.rg-sql.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mysql_server" "server-mysql" {
  name                = "bad-mysqlserver"
  location            = azurerm_resource_group.rg-sql.location
  resource_group_name = azurerm_resource_group.rg-sql.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  # ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "example" {
  name                = "bad-mysqldb"
  resource_group_name = azurerm_resource_group.rg-sql.name
  server_name         = azurerm_mysql_server.server-mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}