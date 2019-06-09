locals {
  modificator = "${var.is_main_cluster == "true" ? 1 : 0}"
}

provider "aws" {
  profile = "${var.provider_profile}"
  region  = "${var.provider_region}"
  version = ">= 1.50.0"
}

resource "aws_route53_record" "metrics" {
  count   = "${local.modificator}"
  name    = "metrics.${var.domain_config["domain_name"]}"
  zone_id = "${var.domain_config["hosted_zone"]}"
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = "${var.balancer_data["zone"]}"
    name = "${var.balancer_data["dns"]}"
  }
}