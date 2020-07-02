output "private_zone" {
  value = {
    name = aws_route53_zone.private.name
    id   = aws_route53_zone.private.zone_id
  }
}