locals {
  modificator = var.network_config.is_main_cluster == true ? 1 : 0
}

provider "aws" {
  profile = var.provider_profile
  region  = var.provider_region
  version = ">= 1.50.0"
}

resource "aws_route53_record" "metrics" {
  count   = local.modificator
  name    = "metrics.${var.network_config.domain_info.domain_name}"
  zone_id = var.network_config.domain_info.hosted_zone
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = var.balancer_data.zone
    name    = var.balancer_data.dns
  }
}