variable "rede_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    type    = string
    default = "10.0.1.0/24"
}

variable "ami" {
    type    = string
    default = "ami-0f409bae3775dc8e5"
}
