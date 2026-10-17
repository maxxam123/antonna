# 1. Create the VPC Attachment to the existing TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

# 2. Inject the routing paths into the VPC Route Tables
resource "aws_route" "vpc_to_tgw" {
  count                  = length(var.vpc_route_table_ids)
  route_table_id         = var.vpc_route_table_ids[count.index]
  destination_cidr_block = var.destination_cidr_block
  transit_gateway_id     = var.transit_gateway_id
}
