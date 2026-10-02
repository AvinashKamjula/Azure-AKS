terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm" }
  }
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_subnet_prefix]

  # avoid provider bug when delegation is removed manually or changed
  lifecycle {
    ignore_changes = [
      delegation,
    ]
    create_before_destroy = true
  }
}

resource "azurerm_subnet" "jumpbox_subnet" {
  name                 = var.jumpbox_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.jumpbox_subnet_prefix]
}

resource "azurerm_subnet" "azure_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.azure_bastion_subnet_prefix]
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "jumpbox_subnet_id" {
  value = azurerm_subnet.jumpbox_subnet.id
}

output "azure_bastion_subnet_id" {
  value = azurerm_subnet.azure_bastion_subnet.id
}
