resource "aws_s3_bucket" "dom4tools_website" {
  bucket = "dom4tools.net"
  acl = "public-read"
  policy = "${file("bucket_hosting_policy.json")}"

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "dom4tools_website_www" {
  bucket = "www.dom4tools.net"

  website = {
    redirect_all_requests_to = "dom4tools.net"
  }
}

resource "aws_route53_zone" "dom4tools_primary" {
  name = "dom4tools.net"
}

resource "aws_route53_record" "dom4tools_primary" {
  zone_id = "${aws_route53_zone.dom4tools_primary.zone_id}"
  name = "dom4tools.net"
  type = "A"

  alias = {
    name = "${aws_s3_bucket.dom4tools_website.website_domain}"
    zone_id = "${aws_s3_bucket.dom4tools_website.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dom4tools_www" {
  zone_id = "${aws_route53_zone.dom4tools_primary.zone_id}"
  name = "www.dom4tools.net"
  type = "A"

  alias = {
    name = "${aws_s3_bucket.dom4tools_website_www.website_domain}"
    zone_id = "${aws_s3_bucket.dom4tools_website_www.hosted_zone_id}"
    evaluate_target_health = false
  }
}
