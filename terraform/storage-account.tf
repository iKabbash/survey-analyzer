# data "external" "public_ip" {
#   program = ["bash", "${path.module}/get_public_ip.sh"]
# }

resource "azurerm_storage_account" "ai_sa" {
  name                     = "aicogsvc${random_id.rand_id.hex}"
  resource_group_name      = azurerm_resource_group.ai_rg.name
  location                 = azurerm_resource_group.ai_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "survey_analyzer"
  }
}

# resource "azurerm_storage_account_network_rules" "ai_sa_network_rules" {
#   storage_account_id         = azurerm_storage_account.ai_sa.id
#   default_action             = "Deny"
#   ip_rules                   = [data.external.public_ip.result.ip, "20.3.165.95"]
#   virtual_network_subnet_ids = [azurerm_subnet.subnet1.id]
#   bypass                     = ["Metrics"]
# }

# upload survey forms
resource "azurerm_storage_container" "sa_container" {
  name                  = "survey-forms"
  storage_account_name  = azurerm_storage_account.ai_sa.name
  container_access_type = "private"
  # depends_on            = [azurerm_storage_account_network_rules.ai_sa_network_rules]
}

locals {
  number_of_blobs = 5
}

resource "azurerm_storage_blob" "sa_blob" {
  count                  = local.number_of_blobs
  name                   = "response-${count.index + 1}.pdf"
  storage_account_name   = azurerm_storage_account.ai_sa.name
  storage_container_name = azurerm_storage_container.sa_container.name
  type                   = "Block"
  source                 = "survey-forms/response-${count.index + 1}.pdf"
  # depends_on             = [azurerm_storage_account_network_rules.ai_sa_network_rules]
}

# # upload applicaton to storage account
# resource "azurerm_storage_container" "app_container" {
#   name                  = "app"
#   storage_account_name  = azurerm_storage_account.ai_sa.name
#   container_access_type = "blob"
#   # depends_on            = [azurerm_storage_account_network_rules.ai_sa_network_rules]
# }

# resource "azurerm_storage_blob" "app_files" {
#   name                   = "app.tar"
#   storage_account_name   = azurerm_storage_account.ai_sa.name
#   storage_container_name = azurerm_storage_container.app_container.name
#   type                   = "Block"
#   source                 = "../app.tar"
# }