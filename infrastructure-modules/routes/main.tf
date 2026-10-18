# infrastructure-modules/vpc-routing/main.tf

# --------------------------------------------------------------------------------------------------
# 1. ENTERPRISE ROUTE TABLES (Dynamically scaled across configured AZs)
# --------------------------------------------------------------------------------------------------
resource "aws_route_table" "private" {
  for_each = var.availability_zones

  vpc_id = var.vpc_id

  tags = merge(
    var.global_tags,
    {
      Name        = "${var.prefix}-${var.environment}-rt-private-${each.key}"
      NetworkTier = "Private"
      SubnetType  = "App"
    }
  )
}

# --------------------------------------------------------------------------------------------------
# 2. SEPARATED ASYMMETRIC ROUTES (Prevents state drift and enables modular modification)
# --------------------------------------------------------------------------------------------------

# Rule A: Firewalled North-South Outbound Traffic to Inspection VPCE
resource "aws_route" "north_south_egress" {
  for_each = var.availability_zones

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = var.fw_endpoints_by_az[each.key]
}

# Rule B: East-West Enterprise Transit Gateway Mesh Backbone
resource "aws_route" "transit_gateway_backhaul" {
  for_each = var.availability_zones  # count = length(var.vpc_cidr_variants) * (var.create_vpc ? 1 : 0)

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = var.corporate_supernet_cidr # e.g., "192.168.0.0/16" or "10.0.0.0/8"
  transit_gateway_id     = var.tgw_id
}

# Rule C: Target Specific Secure Network Interface / Internal Microservice API
resource "aws_route" "internal_api_endpoint" {
  for_each = var.availability_zones

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = var.secure_target_cidr       # e.g., "10.10.50.0/24"
  network_interface_id   = var.vpc_endpoint_eni_ids_by_az[each.key]
}

# --------------------------------------------------------------------------------------------------
# 3. EXPLICIT SUBNET ASSOCIATIONS
# --------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "private_association" {
  for_each = var.availability_zones

  subnet_id      = var.private_subnet_ids_by_az[each.key]
  route_table_id = aws_route_table.private[each.key].id
}
