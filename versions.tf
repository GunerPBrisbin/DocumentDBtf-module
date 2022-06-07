
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.5.0"
      configuration_aliases = [aws.cluster]
    }
  }
  required_version = ">= 1.0.5"
}
