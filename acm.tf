resource "aws_acm_certificate" "example" {
  domain_name = data.aws_route53_zone.example.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example_certificate" {
  name = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
  type = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
  zone_id = data.aws_route53_zone.example.zone_id
  ttl = 60
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = aws_acm_certificate.example.arn
  validation_record_fqdns = [aws_route53_record.example_certificate.fqdn]
}

output "validation_record_fqdns" {
  value = "aws_route53_record.example_certificate.fqdn"
}

output "aws_route53_record_name" {
  value = "aws_route53_record.example_certificate.name"
}
