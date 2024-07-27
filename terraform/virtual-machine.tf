resource "azurerm_public_ip" "analyzer_vm_public_ip" {
  name                = "survey-analyzer-public-ip"
  location            = azurerm_resource_group.ai_rg.location
  resource_group_name = azurerm_resource_group.ai_rg.name
  allocation_method   = "Static"
  domain_name_label   = "survey-analyzer-${random_id.rand_id.hex}"
  tags = {
    environment = "survey_analyzer"
  }
}

resource "azurerm_network_interface" "analyzer_vm_ni" {
  name                = "analyzer-vm-ni"
  location            = azurerm_resource_group.ai_rg.location
  resource_group_name = azurerm_resource_group.ai_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.analyzer_vm_public_ip.id
  }
  tags = {
    environment = "survey_analyzer"
  }
}

resource "azurerm_linux_virtual_machine" "survey_analyzer_vm" {
  name                  = "analyzer-vm-${random_id.rand_id.hex}"
  location              = azurerm_resource_group.ai_rg.location
  resource_group_name   = azurerm_resource_group.ai_rg.name
  size                  = var.vm_size
  admin_username        = "ubuntu"
  network_interface_ids = [azurerm_network_interface.analyzer_vm_ni.id]
  # Install Docker and Python (not recommended to use custom_data as it replaces the VM every terraform apply)
  custom_data = filebase64("setup.tpl")
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.public_key_path)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    environment = "survey_analyzer"
  }
}