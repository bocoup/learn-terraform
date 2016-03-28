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
# S3 bucket for holding static data.
#
resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket}"
  acl = "private"
}

##
# EC2 instance (Ubuntu 14.04)
#
resource "aws_instance" "main" {
  # Ubuntu 14.04 AMI (for us-east-1)
  ami = "ami-fce3c696"
  # A small instance (free tier eligible)
  instance_type = "t2.nano"
  # Use the default key we created
  key_name = "default"
  # Instance profiles can be associated with roles, giving a server
  # access to all the AWS resources the role has permissiosn for.
  # This makes it so AWS credentials do not need to be on the machine.
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  # This controls network access to the server.
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
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {"AWS": "*"},
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

##
# A policy to allow full access to our S3 bucket.
#
resource "aws_iam_policy" "s3" {
  name = "${var.name}-s3-bucket"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
          "arn:aws:s3:::${var.bucket}",
          "arn:aws:s3:::${var.bucket}/*"
      ]
    }
  ]
}
EOF
}

##
# A policy to allow reading metadata (like tags) assigned to instances.
#
resource "aws_iam_policy" "read-tags" {
  name = "${var.name}-read-tags"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    }
  ]
}
EOF
}

##
# Associate policies with our role.
#
resource "aws_iam_policy_attachment" "s3" {
  name = "${var.name}-s3-bucket"
  roles = ["${aws_iam_role.main.id}"]
  policy_arn = "${aws_iam_policy.s3.arn}"
}
resource "aws_iam_policy_attachment" "read-tags" {
  name = "${var.name}-read-tags"
  roles = ["${aws_iam_role.main.id}"]
  policy_arn = "${aws_iam_policy.read-tags.arn}"
}

##
# Associate our role with an instance profile.
#
resource "aws_iam_instance_profile" "main" {
  name = "${var.name}"
  roles = ["${aws_iam_role.main.id}"]
}

##
# A security group that allows:
#  - Outbound communication to any IP.
#  - Inbound SSH and HTTP traffic from any IP.
#
resource "aws_security_group" "main" {
  name = "${var.name}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" { value = "${aws_instance.main.public_ip}" }
