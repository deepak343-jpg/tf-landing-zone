# Azure Infrastructure Landing Zone (Terraform)

A modular, enterprise-ready **Azure Landing Zone** built with HashiCorp **Terraform** using a decoupled **Parent-Child Module** pattern. This project enables dynamic, map-driven provisioning of core Azure infrastructure components including Resource Groups, Virtual Networks, Subnets, Public IPs, Network Interfaces, and Linux Virtual Machines.

---

## 📐 Architecture & Project Structure

The project separates core infrastructure resource logic (**Child Modules**) from environment configuration and state orchestration (**Parent Module**). All infrastructure objects are instantiated dynamically using Terraform `for_each` loops over variable maps.

```
tf-landing-zone/
├── child_module/                # Reusable resource modules
│   ├── publicip/                # Azure Public IP module
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── resource_group/          # Azure Resource Group module
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── subnet/                  # Azure Subnet module
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── virtual_machine/         # Azure Linux VM & NIC module
│   │   ├── data.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   └── virtual_network/         # Azure Virtual Network module
│       ├── main.tf
│       └── variables.tf
│
└── parent_module/               # Root deployment orchestration
    ├── .gitleaks.toml           # Security scanner config for hardcoded secrets
    ├── main.tf                  # Module instantiation & dependency chain
    ├── provider.tf              # AzureRM provider configuration (v4.78.0)
    ├── terraform.tfvars         # Infrastructure target parameters & variable maps
    └── variables.tf             # Input variable declarations
```

---

## 🔄 Deployment Order & Module Dependencies

Modules are chained using explicit Terraform `depends_on` meta-arguments to guarantee deterministic infrastructure provisioning:

```
[Resource Groups] ➔ [Virtual Networks] ➔ [Subnets] ➔ [Public IPs] ➔ [Virtual Machines & NICs]
```

1. **Resource Groups (`child_module/resource_group`)**: Provision container resource groups.
2. **Virtual Networks (`child_module/virtual_network`)**: Provision VNet address spaces.
3. **Subnets (`child_module/subnet`)**: Create subnets scoped to specific VNets & Resource Groups.
4. **Public IPs (`child_module/publicip`)**: Allocate static Public IP addresses.
5. **Virtual Machines (`child_module/virtual_machine`)**: Fetches subnet & public IP references via dynamic `data` sources, builds Network Interfaces (NICs), and deploys Ubuntu Linux VMs (`22_04-lts-gen2`).

---

## ⚙️ Prerequisites & Provider Requirements

- **Terraform**: `>= 1.0.0`
- **Azure CLI**: Logged in with sufficient IAM permissions (`Owner` or `Contributor` role on target subscription)
- **AzureRM Provider**: `hashicorp/azurerm` version `~> 4.78.0`

### Tooling Integration
- **TFLint**: Static analysis for Terraform code (`tflint-report.json`)
- **Gitleaks**: Secret & hardcoded credential detection (`.gitleaks.toml`)
- **Infracost**: Cloud cost breakdown & estimations (`infracost.txt`)

---

## 🚀 Quick Start Guide

### 1. Authenticate to Azure
```bash
az login
az account set --subscription "<YOUR_AZURE_SUBSCRIPTION_ID>"
```

### 2. Navigate to Parent Module
All Terraform execution commands must be run from the `parent_module` directory:
```bash
cd parent_module
```

### 3. Initialize Terraform
Initialize working directory, backend, and download `azurerm` provider:
```bash
terraform init
```

### 4. Review Plan
Validate syntax and inspect execution plan:
```bash
terraform plan
```

### 5. Apply Deployment
Provision resources in Azure:
```bash
terraform apply
```

### 6. Teardown / Cleanup
To destroy all provisioned infrastructure:
```bash
terraform destroy
```

---

## 📋 Configuration Example (`terraform.tfvars`)

Infrastructure parameters are defined in map format inside `parent_module/terraform.tfvars`:

```hcl
rgs = {
  rg1 = {
    name     = "rg-1"
    location = "eastus"
  }
}

vnets = {
  vnet1 = {
    name                = "vnet-1"
    location            = "eastus"
    resource_group_name = "rg-1"
    address_space       = ["10.0.0.0/16"]
  }
}

snets = {
  snet1 = {
    name                 = "snet-1"
    virtual_network_name = "vnet-1"
    resource_group_name  = "rg-1"
    address_prefixes     = ["10.0.0.0/24"]
  }
}

pips = {
  pip1 = {
    name                = "pip01"
    resource_group_name = "rg-1"
    location            = "eastus"
    allocation_method   = "Static"
  }
}

vms = {
  vm1 = {
    nicname             = "nic-frontend"
    location            = "eastus"
    resource_group_name = "rg-1"
    nic_subnet_name     = "snet-1"
    nic_vnet_name       = "vnet-1"
    nic_pip_name        = "pip01"
    vm_name             = "frontend-vm"
    vm_size             = "Standard_DC1ds_v3"
    admin_username      = "adminuser"
    admin_password      = "SecurePassword123!"
    vmsku               = "22_04-lts-gen2"
  }
}
```

---

## 🛡️ Security Best Practices

> [!WARNING]
> Do not commit sensitive credentials or passwords directly into version control.

1. **Secrets Management**: Use Azure Key Vault or environment variables (`TF_VAR_vms`) to pass sensitive values like `admin_password`.
2. **State Storage**: Configure a remote state backend (e.g., Azure Storage Account with state locking enabled) for team collaboration and state protection.
3. **Automated Scanning**: Run `gitleaks detect` prior to pushing commits to prevent accidental disclosure of secrets.

---

## 📄 License

This repository is distributed under the terms of the [Apache License 2.0](LICENSE).
