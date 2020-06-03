data "aws_elb_hosted_zone_id" "main" {}

resource "aws_route53_record" "metrics" {
  name    = "metrics.${var.network_config.domain_info.domain_name}"
  zone_id = var.network_config.domain_info.public_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = data.aws_elb_hosted_zone_id.main.id
    name    = var.balancer_host
  }
}

resource "aws_route53_record" "openvpn" {
  name    = "vpn.${var.network_config.domain_info.domain_name}"
  zone_id = var.network_config.domain_info.public_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = data.aws_elb_hosted_zone_id.main.id
    name    = var.balancer_host
  }
}

resource "aws_route53_record" "public" {
  name    = var.network_config.domain_info.domain_name
  zone_id = var.network_config.domain_info.public_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = data.aws_elb_hosted_zone_id.main.id
    name    = var.balancer_host
  }
}

resource "aws_route53_record" "private" {
  name    = var.network_config.domain_info.domain_name
  zone_id = var.network_config.domain_info.private_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = data.aws_elb_hosted_zone_id.main.id
    name    = var.balancer_host
  }
}
