module "resource_group"{
    source ="../child_module/resource_group"
    rgs = var.rgs
}

module "virtual_network"{
    depends_on = [ module.resource_group ]
    source ="../child_module/virtual_network"
    vnets = var.vnets
}

module "subnets"{
    depends_on = [ module.virtual_network ]
    source ="../child_module/subnet"
    snets = var.snets
}

module "publicip" {
    depends_on = [ module.subnets ]
    source ="../child_module/publicip"
    pips = var.pips
}

module "virtual_machine" {
    depends_on = [ module.publicip ]
    source ="../child_module/virtual_machine"
    vms = var.vms  
}