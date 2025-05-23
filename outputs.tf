output "aws_lb_public_dns" {
  value = aws_lb.app.dns_name
}

