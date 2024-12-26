terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.78"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
