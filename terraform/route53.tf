resource "aws_route53_zone" "primary" {
  name = "eta-oko.com"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "www.eta-oko.com"
  subject_alternative_names = ["eta-oko.com"]  # Covers both www and root domain
  validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation records
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Main A record pointing to ALB
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.eta-oko.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

# Optional: Root domain redirect to www
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eta-oko.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}