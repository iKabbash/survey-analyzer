resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.ai_rg.location
  resource_group_name = azurerm_resource_group.ai_rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "survey_analyzer"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.ai_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.CognitiveServices"]
}

resource "azurerm_network_security_group" "subnet_sg" {
  name                = "vnet-security-group"
  location            = azurerm_resource_group.ai_rg.location
  resource_group_name = azurerm_resource_group.ai_rg.name
  tags = {
    environment = "survey_analyzer"
  }
}

resource "azurerm_network_security_rule" "subnet_sg_rule" {
  name                        = "subnet-sg-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["443", "80", "22"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ai_rg.name
  network_security_group_name = azurerm_network_security_group.subnet_sg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_sg_association" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.subnet_sg.id
}