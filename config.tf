# -------------------------------
# Terraform required version
# -------------------------------
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  
    }
  }

  # Backend configuration
  backend "s3" {
    bucket         = "vazu-terraform-state-bucket"
    key            = "jk_installation_state/dev/state.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

# -------------------------------
# Provider configuration
# -------------------------------
provider "aws" {
  region  ="eu-central-1"
  profile = "techzen"  

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "jk-installation"
      Owner       = "techzen"
    }
  }
}
