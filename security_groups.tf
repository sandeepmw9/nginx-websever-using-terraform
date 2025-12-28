
resource "aws_security_group" "web_sg" {
  name = "web-server-firewall"
}

resource "aws_vpc_security_group_ingress_rule" "in_rules" {
  for_each = toset(var.ports)
  from_port         = each.value
  to_port           = each.value
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_vpc_security_group_egress_rule" "out_rules" {
  from_port         = -1
  to_port           = -1
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.web_sg.id
}