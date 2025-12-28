output "instance_public_ip" {
  value = aws_instance.an_ec2_instance.public_ip
}

output "instance_private_key" {
  value = tls_private_key.for_remote_exec.private_key_openssh
  sensitive = true
}