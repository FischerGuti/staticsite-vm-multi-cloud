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

resource "aws_instance" "temprete" {
    ami                    = "${var.ami}"
    instance_type          = "t2.micro"
    subnet_id              = "${var.subnet_id}"
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    user_data              = "${base64encode(data.template_file.cloud_init.rendered)}"
}


resource "aws_lb" "lb" {
  name               = "lb"
  load_balancer_type = "application"
  subnet_id           = "aws_subnet.sn_public.id"
  security_groups    = [aws_security_group.sg_public.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "tg"
  protocol = "HTTP"
  port     = "80"
  vpc_id   = "${var.rede_id}"
}

resource "aws_lb_listener" "ec2_lb_listener" {
  protocol          = "HTTP"
  port              = "80"
  load_balancer_arn = aws_lb.lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
