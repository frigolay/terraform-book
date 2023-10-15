provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, poops" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
  description = "The public ip address of the instance"
}

output "instance_id" {
  value = aws_instance.example.id
  description = "The instance ID"
}

output "private_ip" {
  value = aws_instance.example.private_ip
  description = "The private ip address of the instance"
}

output "public_hostname" {
  value = aws_instance.example.public_dns
  description = "The public dns for the instance"
}

output "private_hostname" {
  value = aws_instance.example.private_dns
  description = "The private dns for the instance"
}

variable "server_port" {
  description = "HTTP port number"
  type = number
  default = 8080
}

output "Ingress" {
  value = aws_security_group.instance.ingress
  description = "Security group ingress object"
}
