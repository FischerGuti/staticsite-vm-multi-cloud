resource "aws_security_group" "sg_public" {
    name   = "sg_public"
    vpc_id = "${var.rede_id}"
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.rede_cidr}"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        description = "TCP/80 from All"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    

}

data "template_file" "cloud_init" {
    template = "${file("./modules/compute/init/cloud_init.sh")}"
}

resource "aws_instance" "instance" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.subnet_id}"
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
}