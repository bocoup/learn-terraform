# test your terraform configuration
`terraform plan`

# build the infrastructure
`terraform apply`

# Use the AWS CLI to put data on the site
`aws --profile PROFILE_NAME s3 sync staticSite/ s3://DOMAINNAME.BIZ --include '*' --acl 'public-read'`

# visit the website endpoints output by the script and confirm their behavior