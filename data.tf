// Lookup information from the calling resource or from AWS
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
#data "aws_ebs_default_kms_key" "current" {}
#data "aws_ebs_encryption_by_default" "current" {}

locals {

  acct_id = data.aws_caller_identity.current.account_id
  acct    = local.map_acct[local.acct_id]
  region  = data.aws_region.current.name

  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix

  vpc_short = {
    872499233454 = "dss"
    326609289561 = "pss"
  }

  apollo_stack    = "apollo-native-logging-${local.vpc_short[local.acct_id]}"
}

//--------------------------------------------------------------
// Values pulled in from net-vpc TFE remote state
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname     = "terraform.corp.firstrepublic.com"
    organization = "CLOUD"
    workspaces = {
      name = "net-vpc-${var.vpc_name}"
    }
  }
}
data "terraform_remote_state" "apollo" {
  backend = "remote"
  config = {
    hostname     = "terraform.corp.firstrepublic.com"
    organization = "CLOUD"
    workspaces = {
      name = "res-${local.apollo_stack}"
    }
  }
}
