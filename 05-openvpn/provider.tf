terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.64.0"      
        }
    }

    backend "s3" {
        bucket = "expense78s-remote-state"
        key = "expense-dev-vpn"
        region = "us-east-1"
        use_lockfile = true
    }

}

# provide authentication here #
provider "aws" {
    region = "us-east-1"
}