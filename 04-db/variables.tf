variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "db_password" {
    type = string
    sensitive = true
    default = "ExpenseApp1"
}

variable "zone_name" {
    default = "avinexpense.shop"
}