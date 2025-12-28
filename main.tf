resource "aws_instance" "an_ec2_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.for_remote_exec.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name       = var.name
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
