variable "name" { default = "learn-terraform" }
variable "fqdn" { default = "learn-terraform.com" }
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
resource "aws_s3_bucket" "learn-terraform" {
  # ...
}

##
# An EC2 instance (Ubuntu 14.04) for our app to run in.
#
resource "aws_instance" "learn-terraform" {
  # ...
  iam_instance_profile = "${aws_iam_instance_profile.learn-terraform.id}"
  vpc_security_group_ids = [
    "${aws_security_group.learn-terraform.id}",
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
resource "aws_iam_role" "learn-terraform" {
  name = "${var.name}"
  # ...
}

##
# A policy to allow full access to our S3 bucket.
#
resource "aws_iam_policy" "learn-terraform-s3-bucket" {
  name = "${var.name}-s3-bucket"
  # ...
}

##
# A policy to allow reading metadata (like tags) assigned to instances.
#
resource "aws_iam_policy" "learn-terraform-read-tags" {
  name = "${var.name}-read-tags"
  # ...
}

##
# Associate policies with our role.
#
resource "aws_iam_policy_attachment" "learn-terraform-s3-bucket" {
  name = "${var.name}-s3-bucket"
  # ...
}
resource "aws_iam_policy_attachment" "learn-terraform-read-tags" {
  name = "${var.name}-read-tags"
  # ...
}

##
# Associate our role with an instance profile.
#
resource "aws_iam_instance_profile" "learn-terraform" {
  name = "${var.name}"
  # ...
}

##
# A security group that allows:
#  - Outbound communication to any IP.
#  - Inbound SSH and HTTP traffic from any IP.
#
resource "aws_security_group" "learn-terraform" {
  name = "${var.name}"
  # ...
}

output "public_ip" { value = "${aws_instance.learn-terraform.public_ip}" }
