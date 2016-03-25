# INTRODUCTION TO TERRAFORM

## EXERCISE

In order to illustrate how Terraform can control your infrastructure, a series
of instructions are enumerated below. If you have any questions about what is
happening under the hood while running these exercises, please ask!

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
