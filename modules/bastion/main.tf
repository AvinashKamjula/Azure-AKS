resource "azurerm_public_ip" "bastion" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tunneling_enabled   = true
  tags                = var.tags

  ip_configuration {
    name                 = "bastion-ip-configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "${var.jumpbox_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.jumpbox_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                            = var.jumpbox_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.jumpbox_vm_size
  admin_username                  = var.linux_admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.jumpbox.id]
  custom_data = base64encode(<<-CLOUD_INIT
    #cloud-config
    package_update: true
    packages:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
    runcmd:
      - [bash, -lc, "curl -sL https://aka.ms/InstallAzureCLIDeb | bash"]
      - [bash, -lc, "az aks install-cli"]
    CLOUD_INIT
  )
  tags = var.tags

  admin_ssh_key {
    username   = var.linux_admin_username
    public_key = var.ssh_public_key
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_role_assignment" "cluster_user" {
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azurerm_linux_virtual_machine.jumpbox.identity[0].principal_id
  principal_type       = "ServicePrincipal"

  # Avoid directory lookup races when Azure has just created the VM identity.
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "cluster_admin" {
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = azurerm_linux_virtual_machine.jumpbox.identity[0].principal_id
  principal_type       = "ServicePrincipal"

  # Avoid directory lookup races when Azure has just created the VM identity.
  skip_service_principal_aad_check = true
}
