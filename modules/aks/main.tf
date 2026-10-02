data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name            = var.node_pool_name
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    vnet_subnet_id  = var.aks_subnet_id
    os_disk_size_gb = var.os_disk_size_gb
    max_pods        = var.max_pods
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_policy
    dns_service_ip = var.dns_service_ip
    service_cidr   = var.service_cidr
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  azure_active_directory_role_based_access_control {
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = []
    azure_rbac_enabled     = true
  }

  linux_profile {
    admin_username = var.linux_admin_username
    ssh_key {
      key_data = trimspace(var.ssh_public_key)
    }
  }
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "kube_admin_config_raw" {
  value     = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  sensitive = true
}
