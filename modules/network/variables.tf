variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "AKS subnet name"
  type        = string
}

variable "aks_subnet_prefix" {
  description = "AKS subnet CIDR prefix"
  type        = string
}

variable "jumpbox_subnet_name" {
  description = "Subnet for the private cluster administration VM"
  type        = string
}

variable "jumpbox_subnet_prefix" {
  description = "CIDR prefix for the jumpbox subnet"
  type        = string
}

variable "azure_bastion_subnet_prefix" {
  description = "CIDR prefix for the required AzureBastionSubnet (at least /26)"
  type        = string
}
