#### rules #############################

resource "aws_security_group_rule" "mgmt_rule" {
  description = "mgmt"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = var.mgmt_ip
  from_port   = 0
  to_port     = 65535

  security_group_id = aws_security_group.test_sg.id
}

resource "aws_security_group_rule" "rdp_rule" {
  description = "mgmt"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = var.rdp_ip
  from_port   = 3389
  to_port     = 3389

  security_group_id = aws_security_group.test_sg.id
}

resource "aws_security_group_rule" "icmp_rule" {
  description = "icmp"

  type        = "ingress"
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = -1
  to_port     = -1

  security_group_id = aws_security_group.test_sg.id
}



# egress
resource "aws_security_group_rule" "egress_rule" {
  description = "egress - permit all"

  type        = "egress"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 0
  to_port     = 0

  security_group_id = aws_security_group.test_sg.id
}

resource "aws_security_group" "test_sg" {
  name        = "test_sg"
  description = "test acl."

  tags = {
    Name = "test_sg"
  }
}
