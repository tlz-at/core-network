output "account" {
  description = "Account ID"
  value       = "${var.account_id}"
}

output "baseline_version" {
  description = "Version of the baseline module"
  value       = "${module.account-baseline.baseline_version}"
}

# Transit Gateway ID
output "transitgw" {
  value = "${aws_ec2_transit_gateway.transitgw.id}"
}
