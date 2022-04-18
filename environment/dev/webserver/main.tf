#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Remote state to retrieve network data from modules
data "terraform_remote_state" "network" { 
  backend = "s3"
  config = {
    bucket = "${var.env}-project-acs730" 
    key    = "${var.env}/network/terraform.tfstate" 
    region = "us-east-1"                           
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Tags defination
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}

# webserver 
resource "aws_instance" "webserver" {
  count                       = var.ec2_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet_ids[count.index]
  security_groups             = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.prefix)
    }
  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-${count.index + 1}"
    }
  )
}


resource "aws_ebs_volume" "web_ebs" {
  count             = var.ec2_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  size              = 4
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-EBS"
    }
  )
}

# Attach EBS volume
resource "aws_volume_attachment" "ebs_att" {
  count       = var.ec2_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_ebs[count.index].id
  instance_id = aws_instance.webserver[count.index].id
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("project.pub")
}


# Security Group of webserver
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http_ssh_webserver"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description     = "HTTP from Bastion"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  ingress {
    description     = "HTTP from LB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-sg"
    }
  )
}




# Bastion host 
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion"
    }
  )
}
# Security Group for Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_ip}/32", "${var.my_private_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-bastion-sg"
    }
  )
}


# Application Load balancer from alb module


module "alb" {
  source          = "../../../modules/alb"
  env             = var.env
  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
  security_groups = [aws_security_group.lb_sg.id]
  subnets         = data.terraform_remote_state.network.outputs.public_subnet_ids[*]
  prefix          = var.prefix
  default_tags    = var.default_tags
}

resource "aws_security_group" "lb_sg" {
  name        = "allow_http_lb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP from everywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-albsg"
    }
  )
}


#Calling ASG module
module "asg" {
source = "../../../modules/asg"
default_tags = var.default_tags
env = var.env
desired_size = var.desired_size
instance_type = var.instance_type
public_key = aws_key_pair.web_key.key_name
prefix = var.prefix
security_groups = [aws_security_group.webserver_sg.id]
vpc_id = data.terraform_remote_state.network.outputs.vpc_id
lb_target_group_arn = module.alb.target_group_arns[0]
vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnet_ids[*]
}
