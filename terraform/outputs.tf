output "cognitive_services_endpoint" {
  value = azurerm_cognitive_account.cognitive_multi_service.endpoint
}

output "cognitive_services_key" {
  value     = azurerm_cognitive_account.cognitive_multi_service.primary_access_key
  sensitive = true
}

output "vm_dns_name" {
  value = azurerm_public_ip.analyzer_vm_public_ip.fqdn
}

output "vm_public_ip" {
  value = azurerm_public_ip.analyzer_vm_public_ip.ip_address
}