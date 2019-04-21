locals {
  modificator = "${var.is_main_cluster == "true" ? 1 : 0}"
}

provider "aws" {
  profile = "${var.provider_profile}"
  region  = "${var.provider_region}"
  version = ">= 1.50.0"
}

resource "aws_route53_record" "auth" {
  count   = "${local.modificator}"
  name    = "auth.${var.domain_config["domain_name"]}"
  zone_id = "${var.domain_config["hosted_zone"]}"
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = "${var.balancer_zone}"
    name = "${var.balancer_dns}"
  }
}

resource "aws_route53_record" "jira" {
  count   = "${local.modificator}"
  name    = "jira.${var.domain_config["domain_name"]}"
  zone_id = "${var.domain_config["hosted_zone"]}"
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = "${var.balancer_zone}"
    name = "${var.balancer_dns}"
  }
}

resource "aws_route53_record" "wiki" {
  count   = "${local.modificator}"
  name    = "wiki.${var.domain_config["domain_name"]}"
  zone_id = "${var.domain_config["hosted_zone"]}"
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = "${var.balancer_zone}"
    name = "${var.balancer_dns}"
  }
}

resource "aws_route53_record" "git" {
  count   = "${local.modificator}"
  name    = "git.${var.domain_config["domain_name"]}"
  zone_id = "${var.domain_config["hosted_zone"]}"
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = "${var.balancer_zone}"
    name = "${var.balancer_dns}"
  }
}

resource "aws_route53_record" "build" {
  count   = "${local.modificator}"
  name    = "build.${var.domain_config["domain_name"]}"
  zone_id = "${var.domain_config["hosted_zone"]}"
  type    = "A"

  alias {
    evaluate_target_health = false
    zone_id = "${var.balancer_zone}"
    name = "${var.balancer_dns}"
  }
}