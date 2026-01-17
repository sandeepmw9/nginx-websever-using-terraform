terraform {
  required_version = "~> 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
      configuration_aliases = [ aws ]
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}