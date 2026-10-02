variable "resource_group_name" {
  description = "Resource group name to create/use for this deployment"
  type        = string
  default     = "rg-aks-demo"
}

variable "subscription_id" {
  description = "Azure subscription ID. Leave empty to use the default Azure CLI subscription."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "canadacentral"
}

variable "vnet_name" {
  type    = string
  default = "aks-vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "aks_subnet_name" {
  type    = string
  default = "aks-subnet"
}

variable "aks_subnet_prefix" {
  description = "AKS subnet CIDR. Must be large enough for the node pool, load balancer, and surge capacity. /23 is recommended for a 3-node default pool."
  type        = string
  default     = "10.1.0.0/23"
}

variable "jumpbox_subnet_name" {
  description = "Subnet for the private VM used to administer AKS through Azure Bastion"
  type        = string
  default     = "jumpbox-subnet"
}

variable "jumpbox_subnet_prefix" {
  description = "CIDR prefix for the jumpbox subnet"
  type        = string
  default     = "10.1.2.0/24"
}

variable "azure_bastion_subnet_prefix" {
  description = "CIDR prefix for AzureBastionSubnet; Azure requires at least /26"
  type        = string
  default     = "10.1.3.0/26"

  validation {
    condition = can(cidrhost(var.azure_bastion_subnet_prefix, 0)) && try(
      tonumber(split("/", var.azure_bastion_subnet_prefix)[1]) <= 26,
      false
    )
    error_message = "AzureBastionSubnet must be a valid CIDR with a /26 prefix or larger address range."
  }
}

variable "bastion_name" {
  description = "Name of the managed Azure Bastion host"
  type        = string
  default     = "aks-bastion"
}

variable "jumpbox_name" {
  description = "Name of the private Linux VM used to administer AKS"
  type        = string
  default     = "aks-jumpbox"
}

variable "jumpbox_vm_size" {
  description = "Size of the private Linux administration VM"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "bastion_admin_username" {
  description = "Linux username for SSH access to the jumpbox"
  type        = string
  default     = "azureuser"
}

variable "log_analytics_name" {
  type    = string
  default = "la-aks-demo"
}

variable "log_analytics_sku" {
  type    = string
  default = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cluster_name" {
  type    = string
  default = "aks-cluster"
}

variable "aks_admin_user_object_id" {
  description = "Microsoft Entra object ID of the user to grant AKS RBAC Cluster Admin"
  type        = string
  default     = "ec33a233-b836-4e9a-bc04-8fa1c95b121f"
}

variable "dns_prefix" {
  type    = string
  default = "aksdemo"
}

variable "node_pool_name" {
  type    = string
  default = "agentpool"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_vm_size" {
  type    = string
  default = "standard_d2as_v4"
}

variable "os_disk_size_gb" {
  type    = number
  default = 30
}

variable "max_pods" {
  type    = number
  default = 110
}

variable "network_plugin" {
  type    = string
  default = "azure"
}

variable "network_policy" {
  type    = string
  default = "azure"
}

variable "dns_service_ip" {
  type    = string
  default = "10.2.0.10"
}

variable "service_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "docker_bridge_cidr" {
  type    = string
  default = "172.17.0.1/16"
}

variable "linux_admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key contents or path to a public key file for the Linux node admin user"
  type        = string
  default     = ""
}
