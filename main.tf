
resource "tls_private_key" "for_remote_exec" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "for_remote_exec" {
  key_name = "remote-exec-key"
  public_key = tls_private_key.for_remote_exec.public_key_openssh
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
