variable "name" {
  type = string
  default = "nginx-web-server"
}

variable "ports" {
  type = list(string)
  default = [22, 80, 443, 8080]
}

variable "ami" {
  type = string
  default = "ami-00ca570c1b6d79f36"
}

variable "instance_type" {
  type = string
  default = "t3.small"
}