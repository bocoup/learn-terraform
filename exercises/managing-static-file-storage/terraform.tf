##
# The name of the static site
#
variable "rootDomain" { default = "DOMAINNAME.BIZ" }

##
# Authenicate us with AWS
#
provider "aws" {
  region = "us-east-1"
  # Set a profile
}

##
# S3 redirection bucket for the www subdomain
#
resource "aws_s3_bucket" "www" {
  # @see https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
  acl = "public-read"

  website {
    # Redirect all requests to the root domain
  }
}

##
# S3 bucket to store the site itself
#
resource "aws_s3_bucket" "root" {
  # @see https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
  acl = "public-read"


  website {
    # Configure index and error resources
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
