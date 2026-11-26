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
        Component = "acm"
    }
}

variable "zone_name" {
    default = "avinexpense.shop"
}

variable "zone_id" {
    default = "Z08183782IRHLCPX46BAC"
}