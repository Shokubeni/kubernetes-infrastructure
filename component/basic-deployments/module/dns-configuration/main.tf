provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
  version = ">= 2.0"
}

resource "aws_route53_record" "metrics" {
  name    = "metrics.${var.network_config.domain_info.domain_name}"
  zone_id = var.network_config.domain_info.private_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = var.balancer_data.zone
    name    = var.balancer_data.dns
  }
}

resource "aws_route53_record" "public" {
  name    = var.network_config.domain_info.domain_name
  zone_id = var.network_config.domain_info.public_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = var.balancer_data.zone
    name    = var.balancer_data.dns
  }
}

resource "aws_route53_record" "private" {
  name    = var.network_config.domain_info.domain_name
  zone_id = var.network_config.domain_info.private_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = var.balancer_data.zone
    name    = var.balancer_data.dns
  }
}
