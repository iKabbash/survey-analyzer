resource "azurerm_cognitive_account" "cognitive_multi_service" {
  name                  = "survey-anaylzer-${random_id.rand_id.hex}"
  location              = azurerm_resource_group.ai_rg.location
  resource_group_name   = azurerm_resource_group.ai_rg.name
  kind                  = "CognitiveServices"
  sku_name              = "S0"
  custom_subdomain_name = "survey-anaylzer-${random_id.rand_id.hex}"
  depends_on            = [azurerm_subnet.subnet1]
  # network_acls {
  #   default_action = "Deny"
  #   ip_rules       = [data.external.public_ip.result.ip, "20.3.165.95"]
  #   virtual_network_rules {
  #     subnet_id = azurerm_subnet.subnet1.id
  #   }
  # }
  tags = {
    environment = "survey_analyzer"
  }
}