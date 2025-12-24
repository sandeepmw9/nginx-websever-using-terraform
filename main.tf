# resource "aws_instance" "test_local_exec" {
#   ami = "ami-00ca570c1b6d79f36"
#   instance_type  = "t3.medium"
#   tags = {
#     Name = "TESTING LOCAL EXEC"
#     MANAGED_BY = "TERRAFORM"
#     OS = "AMAZON LINUX 2023"
#   }

#   provisioner "local-exec" {
#     command = "echo public_ip = ${self.public_ip}, private_ip = ${self.private_ip} >> details.txt"
#   }
# }

variable "ports" {
  type = list(string)
  default = [22, 80, 443, 8080]
}

resource "aws_instance" "test_remote_exec" {
  ami                    = "ami-00ca570c1b6d79f36"
  instance_type          = "t3.small"
  key_name               = aws_key_pair.for_remote_exec.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name       = "nginx-web-server"
    Managed_by = "Terraform"
    OS_Type    = "Linux(amazon linux 2023)"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.for_remote_exec.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }

  provisioner "local-exec" {
    command = "echo public_ip = ${self.public_ip}, private_ip = ${self.private_ip} >> details.txt"
  }
  depends_on = [ aws_security_group.web_sg ]

}

resource "tls_private_key" "for_remote_exec" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "for_remote_exec" {
  key_name = "remote-exec-key"
  public_key = tls_private_key.for_remote_exec.public_key_openssh
}

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
