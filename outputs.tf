output "public_hostname" {
  value = aws_lb.example.dns_name
  description = "The public dns for the instance"
}
