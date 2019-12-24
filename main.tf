# Connect to the core-logging account to get VPC FlowLog destinations
data "terraform_remote_state" "avm" {
  backend = "remote"

  config {
    organization = "${var.tfe_org_name}"
    hostname     = "${var.tfe_host_name}"

    workspaces {
      name = "${var.tfe_avm_workspace_name}"
    }
  }
}

# Connect to the core-logging account to get S3 buckets
data "terraform_remote_state" "logging" {
  backend = "remote"

  config {
    organization = "${var.tfe_org_name}"
    hostname     = "${var.tfe_host_name}"

    workspaces {
      name = "${var.tfe_core_logging_workspace_name}"
    }
  }
}

module "account-baseline" {
  source                 = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws"
  version                = "~> 0.1.0"
  account_name           = "${var.name}"
  account_type           = "${var.account_type}"
  account_id             = "${var.account_id}"
  okta_provider_domain   = "${var.okta_provider_domain}"
  okta_app_id            = "${var.okta_app_id}"
  region                 = "${var.region}"
  region_secondary       = "${var.region_secondary}"
  role_name              = "${var.role_name}"
  config_logs_bucket     = "${data.terraform_remote_state.logging.s3_config_logs_bucket_name}"
  tfe_host_name          = "${var.tfe_host_name}"
  tfe_org_name           = "${var.tfe_org_name}"
  tfe_avm_workspace_name = "${var.tfe_avm_workspace_name}"
  okta_environment       = "${substr(var.account_type, 0, 3)}"
}

module "tlz_it_operations" {
  source            = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-tlz_it_operations"
  version           = "~> 0.1.0"
  okta_provider_arn = "${module.account-baseline.okta_provider_arn}"
  deny_policy_arns  = "${module.account-baseline.deny_policy_arns}"
}

module "tlz_it_operations_okta" {
  source           = "tfe.tlzdemo.net/TLZ-Demo/tlz_group_membership_manager/okta"
  aws_account_id   = "${var.account_id}"
  okta_hostname    = "${var.okta_provider_domain}"
  tlz_account_type = "${var.account_type}"
  user_emails      = ["${var.users_tlz_it_operations}"]
  api_token        = "${var.okta_token}"
  role_name        = "tlz_it_operations"
}

module "tlz_intra_network" {
  source            = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-tlz_intra_network"
  version           = "~> 0.1.0"
  okta_provider_arn = "${module.account-baseline.okta_provider_arn}"
  deny_policy_arns  = "${module.account-baseline.deny_policy_arns}"
}

# module "tlz_intra_network_okta" {
#   source           = "tfe.tlzdemo.net/TLZ-Demo/tlz_group_membership_manager/okta"
#   aws_account_id   = "${var.account_id}"
#   okta_hostname    = "${var.okta_provider_domain}"
#   tlz_account_type = "${var.account_type}"
#   user_emails      = ["${var.users_tlz_intra_network}"]
#   api_token        = "${var.okta_token}"
#   role_name        = "tlz_intra_network"
# }

module "tlz_inter_network" {
  source            = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-tlz_inter_network"
  version           = "~> 0.1.0"
  okta_provider_arn = "${module.account-baseline.okta_provider_arn}"
  deny_policy_arns  = "${module.account-baseline.deny_policy_arns}"
}

# module "tlz_inter_network_okta" {
#   source           = "tfe.tlzdemo.net/TLZ-Demo/tlz_group_membership_manager/okta"
#   aws_account_id   = "${var.account_id}"
#   okta_hostname    = "${var.okta_provider_domain}"
#   tlz_account_type = "${var.account_type}"
#   user_emails      = ["${var.users_tlz_inter_network}"]
#   api_token        = "${var.okta_token}"
#   role_name        = "tlz_inter_network"
# }

module "tlz_admin" {
  source            = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-tlz_admin"
  version           = "~> 0.1.0"
  okta_provider_arn = "${module.account-baseline.okta_provider_arn}"
  deny_policy_arns  = "${module.account-baseline.deny_policy_arns}"
}

# module "tlz_admin_okta" {
#   source           = "tfe.tlzdemo.net/TLZ-Demo/tlz_group_membership_manager/okta"
#   aws_account_id   = "${var.account_id}"
#   okta_hostname    = "${var.okta_provider_domain}"
#   tlz_account_type = "${var.account_type}"
#   user_emails      = ["${var.users_tlz_admin}"]
#   api_token        = "${var.okta_token}"
#   role_name        = "tlz_admin"
# }

#TODO: Cirrus-630 needs to hook in with okta to provide actual access. Both SecOps and IR roles
module "tlz_security_ir" {
  source                  = "tfe.tlzdemo.net/TLZ-Demo/baseline-common/aws//modules/iam-policy-securityir"
  version                 = "~> 0.1.0"
  okta_provider_arn       = "${module.account-baseline.okta_provider_arn}"
}

resource "aws_dynamodb_table_item" "tlz-core_network_account" {
  table_name = "${data.terraform_remote_state.avm.avm_config_table_name}"
  hash_key   = "${data.terraform_remote_state.avm.avm_config_table_hash}"

  item = <<ITEM
{
  "parameter": {"S": "core_network_account"},
  "value": {"S": "${data.aws_caller_identity.current.account_id}"}
}
ITEM

  provider = "aws.shared_services"
}
