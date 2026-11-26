# creating vpc id in ssm #
resource "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
    type = "String"
    value = module.vpc_test.vpc_id
}

# creating public subnet ids in ssm #
resource "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
    type = "StringList"
    value = join(",",module.vpc_test.public_subnet_ids)
} 

# creating db subnet ids in ssm #
resource "aws_ssm_parameter" "db_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/db_subnet_ids"
    type = "StringList"
    value = join(",",module.vpc_test.database_subnet_ids)
}

# creating private subnet ids in ssm #
resource "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
    type = "StringList"
    value = join(",",module.vpc_test.private_subnet_ids)
}

# creating db subnet group name in ssm #
resource "aws_ssm_parameter" "db_subnet_group_name" {
    name = "/${var.project_name}/${var.environment}/db_subnet_group_name"
    type = "String"
    value = module.vpc_test.db_subnet_group_name
}