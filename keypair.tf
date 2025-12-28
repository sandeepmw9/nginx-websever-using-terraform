resource "tls_private_key" "for_remote_exec" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "for_remote_exec" {
  key_name = "remote-exec-key"
  public_key = tls_private_key.for_remote_exec.public_key_openssh
}