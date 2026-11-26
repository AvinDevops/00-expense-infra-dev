## sg ##
# db sg #
module "db" {
    # source = "../../115-terraform-aws-securitygroup"
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "db"
    sg_description = "sg for db mysql instances"
    common_tags = var.common_tags
}
# backend sg #
module "backend" {
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "backend"
    sg_description = "sg for backend instances"
    common_tags = var.common_tags
}
# frontend sg #
module "frontend" {
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "frontend"
    sg_description = "sg for frontend instances"
    common_tags = var.common_tags
}
# bastion sg #
module "bastion" {
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "bastion"
    sg_description = "sg for bastion instance"
    common_tags = var.common_tags
}
# app-alb #
module "app_alb" {
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "app_alb"
    sg_description = "sg for app alb"
    common_tags = var.common_tags
}

# web-alb #
module "web_alb" {
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "web_alb"
    sg_description = "sg for web alb"
    common_tags = var.common_tags
}

# vpn #
module "vpn" {
    source = "git::https://github.com/AvinDevops/115-terraform-aws-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "vpn"
    sg_description = "sg for vpn"
    common_tags = var.common_tags
    inbound_rules = var.vpn_sg_rules
}

### sg rules ###
## backend ##
# db accepting connections from backend #
resource "aws_security_group_rule" "db_backend" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.backend.sg_id
}

# db accepting connections from bastion #
resource "aws_security_group_rule" "db_bastion" {
    type = "ingress"
    from_port = 3306
    to_port =3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.bastion.sg_id
}

# db accepting connections from vpn #
resource "aws_security_group_rule" "db_vpn" {
    type = "ingress"
    from_port = 3306
    to_port =3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.vpn.sg_id
}

## backend ##
# backend accepting connection from app_alb #
resource "aws_security_group_rule" "backend_app_alb" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.app_alb.sg_id
}

# backend accepting connection from bastion #
resource "aws_security_group_rule" "backend_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.bastion.sg_id
}

# backend accepting connection from vpn_ssh #
resource "aws_security_group_rule" "backend_vpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.vpn.sg_id
}

# backend accepting connection from vpn_http #
resource "aws_security_group_rule" "backend_vpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.vpn.sg_id
}

## app_alb ##
# app_alb accepting connection from vpn #
resource "aws_security_group_rule" "app_alb_vpn" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id
    source_security_group_id = module.vpn.sg_id
}

# app_alb accepting connection from frontend  #
resource "aws_security_group_rule" "app_alb_frontend" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id
    source_security_group_id = module.frontend.sg_id
}

# app_alb accepting connection from bastion  #
resource "aws_security_group_rule" "app_alb_bastion" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id
    source_security_group_id = module.bastion.sg_id
}

## frontend ##
# frontend accepting connection from web_alb #
resource "aws_security_group_rule" "frontend_web_alb" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.web_alb.sg_id
}

# frontend accepting connection from vpn #
resource "aws_security_group_rule" "frontend_vpn" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.vpn.sg_id
}

# frontend accepting connection from bastion #
resource "aws_security_group_rule" "frontend_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.bastion.sg_id
}

## web_alb ##
# web_alb accepting connection from public #
resource "aws_security_group_rule" "web_alb_public" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.web_alb.sg_id
    cidr_blocks = ["0.0.0.0/0"]
}

# web_alb accepting connection from public_https #
resource "aws_security_group_rule" "web_alb_public_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = module.web_alb.sg_id
    cidr_blocks = ["0.0.0.0/0"]
}

## bastion ##
# bastion accepting onnections from public #
resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
    
}
