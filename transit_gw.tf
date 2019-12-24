# Transit Gateway

resource "aws_ec2_transit_gateway" "transitgw" {
  description                     = "Transit Gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "enable"
}

# AWS RAM
resource "aws_ec2_transit_gateway_route_table" "tgw-main-rt" {
  transit_gateway_id = "${aws_ec2_transit_gateway.transitgw.id}"
  depends_on         = ["aws_ec2_transit_gateway.transitgw"]
}

# AWS Resource Association Manager 
resource "aws_ram_resource_share" "transit-gw" {
  name                      = "tlz-transit-gw"
  allow_external_principals = false
}

resource "aws_ram_resource_association" "transit-gw" {
  resource_arn       = "${aws_ec2_transit_gateway.transitgw.arn}"
  resource_share_arn = "${aws_ram_resource_share.transit-gw.arn}"
}

resource "aws_ram_principal_association" "transit-gw1" {
  principal          = "arn:aws:organizations::${var.master_payer_account}:organization/${var.master_payer_org_id}"
  resource_share_arn = "${aws_ram_resource_share.transit-gw.arn}"
}
