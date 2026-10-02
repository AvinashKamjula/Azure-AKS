output "bastion_host_name" {
  description = "Managed Azure Bastion host name"
  value       = azurerm_bastion_host.this.name
}

output "jumpbox_vm_name" {
  description = "Private Linux jumpbox VM name"
  value       = azurerm_linux_virtual_machine.jumpbox.name
}

output "jumpbox_private_ip" {
  description = "Private IP address of the jumpbox"
  value       = azurerm_network_interface.jumpbox.private_ip_address
}

output "bastion_connection_command" {
  description = "Azure CLI command to SSH to the jumpbox through Azure Bastion; replace PRIVATE_KEY_PATH with the local SSH private-key path"
  value       = "az network bastion ssh --name ${azurerm_bastion_host.this.name} --resource-group ${var.resource_group_name} --target-resource-id ${azurerm_linux_virtual_machine.jumpbox.id} --auth-type ssh-key --username ${var.linux_admin_username} --ssh-key \"PRIVATE_KEY_PATH\""
}
