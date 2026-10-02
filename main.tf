terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source                      = "./modules/network"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = var.location
  vnet_name                   = var.vnet_name
  address_space               = var.address_space
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_prefix           = var.aks_subnet_prefix
  jumpbox_subnet_name         = var.jumpbox_subnet_name
  jumpbox_subnet_prefix       = var.jumpbox_subnet_prefix
  azure_bastion_subnet_prefix = var.azure_bastion_subnet_prefix
}

module "log_analytics" {
  source              = "./modules/log_analytics"
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_in_days
  tags                = var.tags
}

module "aks" {
  source                     = "./modules/aks"
  name                       = var.cluster_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this.name
  dns_prefix                 = var.dns_prefix
  node_pool_name             = var.node_pool_name
  node_count                 = var.node_count
  node_vm_size               = var.node_vm_size
  aks_subnet_id              = module.network.aks_subnet_id
  os_disk_size_gb            = var.os_disk_size_gb
  max_pods                   = var.max_pods
  network_plugin             = var.network_plugin
  network_policy             = var.network_policy
  dns_service_ip             = var.dns_service_ip
  service_cidr               = var.service_cidr
  docker_bridge_cidr         = var.docker_bridge_cidr
  log_analytics_workspace_id = module.log_analytics.workspace_id
  linux_admin_username       = var.linux_admin_username
  ssh_public_key = var.ssh_public_key != "" ? (
    startswith(trimspace(var.ssh_public_key), "ssh-") ? trimspace(var.ssh_public_key) : trimspace(file("${path.root}/${trimspace(var.ssh_public_key)}"))
  ) : trimspace(file("${path.root}/y.pub"))
}

module "bastion" {
  source               = "./modules/bastion"
  name                 = var.bastion_name
  jumpbox_name         = var.jumpbox_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.this.name
  bastion_subnet_id    = module.network.azure_bastion_subnet_id
  jumpbox_subnet_id    = module.network.jumpbox_subnet_id
  jumpbox_vm_size      = var.jumpbox_vm_size
  linux_admin_username = var.bastion_admin_username
  ssh_public_key = var.ssh_public_key != "" ? (
    startswith(trimspace(var.ssh_public_key), "ssh-") ? trimspace(var.ssh_public_key) : trimspace(file("${path.root}/${trimspace(var.ssh_public_key)}"))
  ) : trimspace(file("${path.root}/y.pub"))
  aks_cluster_id = module.aks.aks_cluster_id
  tags           = var.tags
}

resource "azurerm_role_assignment" "current_user_aks_admin" {
  scope                = module.aks.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = var.aks_admin_user_object_id
  principal_type       = "User"
}
