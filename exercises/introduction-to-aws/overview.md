# INTRODUCTION TO AWS
Amazon provides a vast platform for web infrastructure, a comprehensive,
granular permissions system for controlling access, and broad set of purpose
built tools for developers that need to interact with the platform.

Once you have an Amazon AWS account the best place to get familiar with what
the AWS ecosystem has to offer is via the web based [AWS Console]. For the
purpose of this exercise we'll be focusing on secure user access.

## IAM
The acronym IAM stands for: [Identity and Access Management]. Amazon has a
multi-faceted approach to security and there are many ways an account's
administrator can go about granting or denying access to various AWS resources.

### USERS
When you first signed up for an AWS account and created a username and
password you created what Amazon refers to as the "root account". These
credentials grant access ONLY to the web interface but provide no credentials
for using any of Amazon's tools which provide programmatic access. This is by
design, and is Amazon's way of preventing folks from managing their
infrastructure as the root user.

To create new users or view existing ones checkout the [Users IAM page] of the
AWS Console. At creation time, each user is assigned an `Access Key ID` and
`Secret Access Key`. These may be regenerated at any time, and a maximum of
two can be attached to any user. The `Secret Access Key` is only available at
generation time so don't forget to download or copy it down!

### GROUPS
Groups, as you may have expected, are a way to manage AWS resource access for a
collection of users. Users can be members of more than one group.

### ROLES
As we've discussed previously, sharing deployment related secrets is a complex
and difficult task. Roles are Amazon's way of helping us mitigate some of that
overhead. Roles let us define inter-resource access paradigms that allow say, a
server to upload files to an S3 bucket, without that server needing to be
provisioned with user credentials.

Roles can be created in the [Roles IAM section] of the AWS Console and many
purpose built ones are available to be used without needing to write one from
scratch.

## THE AWS CLI
One of the programmatic tools Amazon provides is its command line interface.
The [AWS CLI can be downloaded from here]. In order to use the command line
you must have your user account's `Secret Access Key` and `Access Key ID`.
The tool supports many "profiles", meaning you can use the CLI to act in
multiple AWS environments (work, personal, client, etc.) without needing to
authenticate every time.

The file that contains these profiles is located in `~/.aws/credentials`.

It looks something like this:

```
[personal]
aws_access_key_id = SOMEKEY
aws_access_secret_key_id = SOMEOTHERKEY

[work]
aws_access_key_id = SOMEKEY
aws_access_secret_key_id = SOMEOTHERKEY
```

Rather than manually edit this file, you can generate new profile with the
`configure` command:

```
aws configure --profile=personal
```

Many tools including Ansible and Terraform can be made to use AWS profiles by
passing in the `AWS_PROFILE` environment variable, or utilizing built-in profile
support.

## WHY NOT USE THE CLI FOR EVERYTHING?
The AWS CLI is incredibly powerful and there's no reason it can't be used to
accomplish many tasks in place of Ansible, Terraform, etc. However the CLI is
akin to a shell script, it's not necessarily idempotent, and it has no
mechanism to track the current or previous states of your infrastructure.

If you just need to copy some files into an S3 bucket, you may be well served by
using the CLI rather than Ansible or Terraform.

## EXERCISE
In this exercise you'll login to the AWS Console with root credentials and
create a new user. Copy the credentials which were generated at runtime and
generate a profile called `personal` (or anything really) on your local machine.

Then, use the AWS Console to grant the `AdministratorAccess` policy for your
user. You'll know everything worked when you can run the following command in
the terminal and see the user you just created listed:

```
aws iam list-users --profile=personal
```

## LEARNING OBJECTIVES

- Where are new users, groups, and roles created in the AWS web portal?
- How and when are user credentials distributed?
- What is the difference between groups and roles?
- How do applications like Terraform authenticate with cloud providers?
- When is the AWS CLI tool a better choice than Terraform or Ansible?
- How does Terraform interact with the AWS API?
- What does Terraform share with the AWS CLI?

[AWS Console]: https://console.aws.amazon.com
[Identity and Access Management]: https://console.aws.amazon.com/iam/home
[Users IAM page]: https://console.aws.amazon.com/iam/home#users
[Roles IAM section]: https://console.aws.amazon.com/iam/home#roles
[AWS CLI can be downloaded from here]: https://aws.amazon.com/cli/
