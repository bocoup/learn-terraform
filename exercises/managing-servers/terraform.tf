##
# The prefix we will use for resource names.
#
variable "name" { default = "learn-terraform" }

##
# The fully qualified domain name we will tag our instance with.
#
variable "fqdn" { default = "learn-terraform.com" }

##
# The bucket our application stores files in.
# S3 buckets share a global namespace across all AWS accounts.
# You will need to change this to something unique.
#
variable "bucket" { default = "learn-terraform-bucket" }

##
# Authenicate us with AWS
#
provider "aws" {
  region = "us-east-1"
  profile = "YOUR_PROFILE_NAME"
}

##
# A S3 bucket for holding static data.
#
resource "aws_s3_bucket" "main" {
  # ...
}

##
# An EC2 instance (Ubuntu 14.04) for our app to run in.
#
resource "aws_instance" "main" {
  # ...
  iam_instance_profile = "${aws_iam_instance_profile.main.id}"
  vpc_security_group_ids = [
    "${aws_security_group.main.id}",
  ]
  tags {
    "Name" = "${var.name}"
    "fqdn" = "${var.fqdn}"
    "bucket" = "${var.bucket}"
  }
}

##
# A role to receive permissions from the IAM policy system.
#
resource "aws_iam_role" "main" {
  name = "${var.name}"
  # ...
}

##
# A policy to allow full access to our S3 bucket.
#
resource "aws_iam_policy" "s3" {
  name = "${var.name}-s3-bucket"
  # ...
}

##
# A policy to allow reading metadata (like tags) assigned to instances.
#
resource "aws_iam_policy" "read-tags" {
  name = "${var.name}-read-tags"
  # ...
}

##
# Associate policies with our role.
#
resource "aws_iam_policy_attachment" "s3" {
  name = "${var.name}-s3-bucket"
  # ...
}
resource "aws_iam_policy_attachment" "read-tags" {
  name = "${var.name}-read-tags"
  # ...
}

##
# Associate our role with an instance profile.
#
resource "aws_iam_instance_profile" "main" {
  name = "${var.name}"
  # ...
}

##
# A security group that allows:
#  - Outbound communication to any IP.
#  - Inbound SSH and HTTP traffic from any IP.
#
resource "aws_security_group" "main" {
  name = "${var.name}"
  # ...
}

output "public_ip" { value = "${aws_instance.main.public_ip}" }
