provider "aws" {
  region = "us-east-1"
  profile = "YOUR_PROFILE_HERE"
}

resource "aws_iam_user" "user" {
  name = "user"
  #path = "/department/"
}

#resource "aws_iam_policy" "describe-access" {
#  name = "describe-access"
#  description = "Allow the retrieval of ec2 instance descriptions."
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "ec2:Describe*"
#      ],
#      "Effect": "Allow",
#      "Resource": "*"
#    }
#  ]
#}
#EOF
#}
#resource "aws_iam_policy_attachment" "describe-access" {
#  name = "describe-access"
#  users = ["${aws_iam_user.user.id}"]
#  policy_arn = "${aws_iam_policy.describe-access.arn}"
#}
