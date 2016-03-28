##
# The name of the static site
#
variable "rootDomain" { default = "change.me" }

##
# Authenicate us with AWS
#
provider "aws" {
  region = "us-east-1"
  profile = "YOUR_PROFILE_NAME"
}

##
# S3 redirection bucket for the www subdomain
#
resource "aws_s3_bucket" "www" {
  bucket = "www.${var.rootDomain}"
  acl = "public-read"

  website {
    redirect_all_requests_to = "${var.rootDomain}"
  }
}

##
# Render S3 Bucket Policy Template
#
resource "template_file" "root_bucket_policy" {
  template = "${file("${path.module}/s3policy.json.tpl")}"

  vars {
    bucket_name = "${var.rootDomain}"
  }
}

##
# S3 bucket to store the site itself
#
resource "aws_s3_bucket" "root" {
  bucket = "${var.rootDomain}"
  acl = "public-read"
  policy = "${template_file.root_bucket_policy.rendered}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

##
# If you want to hook up DNS you will need to reference the variables
#  ${aws_s3_bucket.www.website_endpoint}
#  ${aws_s3_bucket.root.website_endpoint}
#

##
# Output the website endpoints for testing
#
output "www" { value = "${aws_s3_bucket.www.website_endpoint}" }
output "root" { value = "${aws_s3_bucket.root.website_endpoint}" }