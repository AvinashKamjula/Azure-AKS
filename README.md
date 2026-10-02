STEP-1: CLONE THE CODE
git clone https://github.com/RAHAMSHAIK007/AZURE-PRO.git

STEP-2: INSTALL AZURE AZURE CLI
winget install -e --id Microsoft.AzureCLI

az login --use-device-code


STEP-3: RUN COMMANDS
terraform init
terraform validate
terraform plan -out eks
terraform apply

## Azure Bastion access to AKS

Terraform also creates an Azure Bastion host and a private Ubuntu jumpbox in the
VNet. The jumpbox has Azure CLI, `kubectl`, and `kubelogin` installed. Its
system-assigned managed identity is granted AKS Cluster User and AKS RBAC Cluster
Admin roles. Azure RBAC authorization is enabled on the AKS cluster for this
identity-based access.

After `terraform apply`:

1. In the Azure portal, open the VM named by `terraform output -raw jumpbox_vm_name`.
2. Select **Connect > Bastion**, choose SSH, and connect with the configured
	Linux username and the matching private key.
3. On the jumpbox, authenticate its managed identity and load the cluster context:

	```sh
	az login --identity
	az aks get-credentials --resource-group rg-aks-demo --name aks-cluster
	kubectl get nodes
	```

Replace the resource group and cluster name if you changed their Terraform
variables. The VM has no public IP; SSH is brokered by the managed Bastion
service. The AKS API endpoint configuration is unchanged (this does not make the
API private). The Bastion Standard SKU and cluster-admin role assignment incur
Azure charges and grant the jumpbox identity full administrative access to this
cluster.