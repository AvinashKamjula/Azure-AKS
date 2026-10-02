output "aks_cluster_id" {
  description = "AKS cluster resource id"
  value       = module.aks.aks_cluster_id
}

output "kube_admin_config_raw" {
  description = "Raw kubeadmin config (sensitive)"
  value       = module.aks.kube_admin_config_raw
  sensitive   = true
}

output "vnet_id" {
  description = "VNet id created by the network module"
  value       = module.network.vnet_id
}

output "bastion_host_name" {
  description = "Managed Azure Bastion host name"
  value       = module.bastion.bastion_host_name
}

output "jumpbox_vm_name" {
  description = "Private Linux VM name to select when connecting through Azure Bastion"
  value       = module.bastion.jumpbox_vm_name
}

output "jumpbox_private_ip" {
  description = "Private IP address of the AKS administration VM"
  value       = module.bastion.jumpbox_private_ip
}

output "bastion_connection_command" {
  description = "Azure CLI SSH command to connect to the jumpbox through Bastion; replace PRIVATE_KEY_PATH with your local SSH private-key path"
  value       = module.bastion.bastion_connection_command
}

