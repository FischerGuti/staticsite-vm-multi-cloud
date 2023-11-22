module "rede" {
    source      = "./modules/compute"
    rede_cidr   = "${var.rede_cidr}"
    subnet_cidr = "${var.subnet_cidr}"
}

module "compute" {
    source     = "./modules/compute"
    rede_id    = "${module.rede.vpc_id}"
    subnet_id  = "${module.rede.subnet_id}"
    rede_cidr  = "${var.rede_cidr}"
    ami        = "${var.ami}"
    depends_on = [module.rede]
}
