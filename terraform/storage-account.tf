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

# upload survey forms
resource "azurerm_storage_container" "sa_container" {
  name                  = "survey-forms"
  storage_account_name  = azurerm_storage_account.ai_sa.name
  container_access_type = "private"
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
}