rgs = {
  rg1 = {
    name     = "rg-1"
    location = "eastus"
  }

  rg2 = {
    name     = "rg-2"
    location = "eastus"
  }

  rg2 = {
    name     = "rg-3"
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

  vnet2 = {
    name                = "vnet-2"
    location            = "eastus"
    resource_group_name = "rg-2"
    address_space       = ["10.1.0.0/16"]
  }
}

snets = {
  snet1 = {
    name                 = "snet-1"
    virtual_network_name = "vnet-1"
    resource_group_name  = "rg-1"
    address_prefixes     = ["10.0.0.0/24"]
  }

  snet2 = {
    name                 = "snet-2"
    virtual_network_name = "vnet-2"
    resource_group_name  = "rg-2"
    address_prefixes     = ["10.1.0.0/24"]
  }
}

pips = {
  pip1 = {
    name                = "pip01"
    resource_group_name = "rg-1"
    location            = "eastus"
    allocation_method   = "Static"
  }
  pip2 = {
    name                = "pip02"
    resource_group_name = "rg-2"
    location            = "eastus"
    allocation_method   = "Static"
  }
}

nics = {
  nic01 = {
    name                = "nic-frontend"
    location            = "eastus"
    resource_group_name = "rg-1"
  }

  nic02 = {
    name                = "nic-backend"
    location            = "eastus"
    resource_group_name = "rg-2"
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
    admin_username      = "deepakg"
    admin_password      = "Bangalore123#"
    vmsku               = "22_04-lts-gen2"
  }

  vm2 = {
    nicname             = "nic-backend"
    location            = "eastus"
    resource_group_name = "rg-2"
    nic_subnet_name     = "snet-2"
    nic_vnet_name       = "vnet-2"
    nic_pip_name        = "pip02"
    vm_name             = "backend-vm"
    vm_size             = "Standard_DC1s_v3"
    admin_username      = "deepakg"
    admin_password      = "Bangalore123#"
    vmsku               = "22_04-lts-gen2"
  }
}