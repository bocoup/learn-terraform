# INTRODUCTION TO TERRAFORM

Terraform is a tool for building, changing, and versioning infrastructure.
Using it's declarative configuration, you can describe the components needed to
run a single application or an entire datacenter.

## PROVIDERS

Terraform can manage infrastructure on a wide array of [providers], such as
[AWS], [DigitalOcean], etc. Once a provider has been authenticated, Terraform
gains the ability to manage [resources] for it.

Here in example of configuring Terraform to manage AWS:
```
provider "aws" {
  region = "us-east-1"
  profile = "YOUR_PROFILE_HERE"
}
```

This relies on the operator having installed and configured the AWS command line
tool. Terraform will look for the credentials of the specified profile in the
same location as the AWS CLI (`~/.aws/credentials`).

This is the ideal way to authenticate Terraform with AWS. If you opt to specify
your credentials in-line, do not check them in to source control!

## RESOURCES & VARIABLES

Once Terraform is authenticated with a provider, you can use it to manage any
type of infrastructure there is a corresponding "resource" for.

For example, this configuration will ensure there is a small Ubuntu instance
running in your AWS infrastructure, with a DNS entry that makes it possible
to address the machine using `mywebsite.com`.

```
provider "aws" {
  region = "us-east-1"
  profile = "YOUR_PROFILE_HERE"
}

resource "aws_instance" "webserver" {
  ami = "ami-fce3c696"
  instance_type = "t2.nano"
  key_name = "default"
  tags {
    Name = "mywebsite.com"
  }
}

resource "aws_route53_zone" "main" {
  name = "mywebsite.com"
}

resource "aws_route53_record" "main" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name = "mywebsite.com"
  type = "A"
  ttl = "1"
  records = [
    "${aws_instance.webserver.public_ip}"
  ]
}
```

Note how the DNS entries reference values from other resources using the `${}`
form. This is a critically important piece of what makes Terraform so powerful
for managing infrastructure. If, for example, you decided to replace your server
and the public IP changed, Terraform would automatically manage the DNS change
as well.


## EXERCISE

In order to illustrate how Terraform can version your infrastructure, a series
of instructions are enumerated below. Open the included `terraform.tf` config
file for reference and run through the steps below.

> Note the resources that will be created.
```
terraform plan
```

> Bring your infrastructure in sync with the Terraform config.
> Locate the user in the AWS control panel after running this.
```
terraform apply
```

> Note that Terraform recorded the state of your infrastructure, mapping
> the internal ids at AWS with the resources in your .tf file.
```
cat terraform.tfstate
```

> Perform a three-way check between your existing infrastructure, your
> Terraform config, and your .tfstate file. Note that Terraform sees
> everything is in sync and nothing needs to be changed.
```
terraform plan
```

> Delete the user manually in AWS control panel. Then, perform a three-way check
> between your existing infrastructure, your Terraform config, and your .tfstate
> file. Note that Terraform knows a resource was removed out-of-band wants to
> create it again.
```
terraform plan
```

> Bring your infrastructure in sync with the Terraform config.
```
terraform apply
```

> Remove your local state file.
```
rm terraform.tfstate
```

> Note that Terraform is no longer aware of what it has created and wants to
> add the user again.
```
terraform plan
```

> Note that this fails because a conflicting resource exists. Terraform cannot
> recover from this without manual intervention.
```
terraform apply
```

> Delete the user in AWS control panel. Then, uncomment the `aws_iam_policy` and
> `aws_iam_policy_attachment` blocks. Finally, bring your infrastructure in sync
> with the new configuration.
```
terraform apply
```

> Uncomment the path option for the user and comment out the description option
> for the policy. Note that sometimes a resource can be modified, and other
> times it must be re-created.
```
terraform plan
```

> Bring your infrastructure in sync with the Terraform config.
```
terraform apply
```

> Ensure you have graphviz installed.
```
# for osx
brew install graphviz
# or debian/ubuntu
sudo apt-get install graphviz
# or arch
sudo pacman install graphviz
```

> Show that terraform understands the dependencies between your resources.
```
terraform graph | dot -Tpdf > graph.pdf && open graph.pdf
```

> Destroy your created infrastructure entirely.
```
terraform destroy
```

_**Note:** For simplicity, we omitted saving plan files in the exercises above.
When working with real infrastructure it is advisable to do so by running
`terraform plan -out planfile`. When applying the planned changes, use the saved
plan like so: `terraform apply planfile`.

If Terraform sees your infrastructure has changed between the time you made
the plan and the time you tried to apply it, it will abort, protecting you from
unexpected infrastructure changes._

## LEARNING OBJECTIVES

- What is Terraform?
- What are providers?
- What are resources?
- How does Terraform know the state of your infrastructure?
- How can you tell if a change is going to modify an existing resource?
- How can you tell if a change is going to create a new resource?
- How do you reference a value from one resource in another?
- How does `terraform plan` work?
- How does `terraform apply` work?
- How does Terraform graph your infrastructure?

[providers]: https://www.terraform.io/docs/providers/index.html
[AWS]: https://www.terraform.io/docs/providers/aws/index.html
[resources]: https://www.terraform.io/docs/providers/aws/index.html
[DigitalOcean]: https://www.terraform.io/docs/providers/do/index.html
