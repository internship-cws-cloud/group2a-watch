terraform {
  required_version = "~> 1.9"

  backend "s3" {
    bucket         = "group2a-tfstate-210842714008" # YOUR bucket
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "group2a-tflock" # YOUR table
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.region

  # Every resource gets these tags without you writing them each time.
  # The Group tag is what makes per-group cost reporting possible.
  default_tags {
    tags = {
      Group     = var.group_name
      Programme = "cloud-internship"
      ManagedBy = "terraform"
    }
  }
}
