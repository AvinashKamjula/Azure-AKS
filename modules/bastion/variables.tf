variable "name" {
  description = "Managed Azure Bastion host name"
  type        = string
}

variable "jumpbox_name" {
  description = "Private Linux VM name"
  type        = string
}

variable "location" {
  description = "Azure region for the Bastion host and jumpbox"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the Bastion host and jumpbox"
  type        = string
}

variable "bastion_subnet_id" {
  description = "ID of the dedicated AzureBastionSubnet"
  type        = string
}

variable "jumpbox_subnet_id" {
  description = "ID of the private jumpbox subnet"
  type        = string
}

variable "jumpbox_vm_size" {
  description = "Jumpbox virtual machine size"
  type        = string
}

variable "linux_admin_username" {
  description = "Linux administrator username for SSH"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key used to access the jumpbox"
  type        = string
}

variable "aks_cluster_id" {
  description = "AKS cluster resource ID to grant the jumpbox identity access to"
  type        = string
}

variable "tags" {
  description = "Tags applied to Bastion resources"
  type        = map(string)
  default     = {}
}
