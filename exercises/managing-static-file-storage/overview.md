# MANAGING STATIC FILE STORAGE

Most cloud providers offer some form of scalable flat file storage. For this
exercise we will focus on Amazon S3.

## WHAT IS S3
S3 stands for Simple Storage Service and is Amazon's pay-per-use storage
solution for static files. In addition to being [ludicrously cheap], it allows
fine grained permissions control, making it appropriate for a wide range of
uses.

### PUBLIC / PRIVATE ACCESS
By default, files stored in S3 are private. Quite often, this is desirable. You
might, for example, store encrypted database backups on S3.

You can also make files publicly readable. This approach is common for storing
long-lived assets like images. These files can be accessed via URL like so:

```
https://s3.amazonaws.com/<bucket_name>/<file_name>
```

You can also make files in S3 buckets accessible via a custom domain. Here are
two examples of the same file:

https://s3.amazonaws.com/static.bocoup.com/img/bocoup.png
http://static.bocoup.com/img/bocoup.png

Try using `dig` to see what the DNS record for `static.bocoup.com` looks like!

### STATIC FILE HOSTING
If you were thinking a S3 bucket could be a great place to host a static website
you would be right! In fact, S3 supports this explicitly by allowing a bucket
to be configured with an index document, an error document, and simple
redirection rules.

If you want to host directly from an S3 bucket, you'll have to coordinate the
bucket name and the domain name. To host `www.wakawaka.com`, for example, your
S3 bucket should be named `www.wakawaka.com`.

If you're hosting a static single page application that uses client-side routing
it's likely you'll have to set your error document to the same resource as your
index document. That way when you visit a page that doesn't exist, AWS will
still serve the index page (the client side router will take care of the rest).

The downside to this is that your site will not return the `200` http code for
most requests, though this can be [mitigated] by using Cloudfront, Amazon's CDN.
Also, server-side rendering is out of the picture.

Once you have your bucket configured appropriately, you can wire up DNS by
setting a `CNAME` record to the bucket's `website_endpoint` value.

### REDIRECT BUCKETS
Because buckets can only respond to requests from domains that match their name,
supporting subdomains is a bit circuitous. For example, if the canonical version
of your site should be `www.yoursite.com`, you'll want requests made to
`yoursite.com` to be redirected to `www.yoursite.com`.

Thankfully, S3 has a purpose built "redirection mode" for buckets. Simply create
an empty bucket with the name `yoursite.com` and configure it to redirect all
requests to `www.yoursite.com`.

### ACCESS POLICIES
S3 buckets support fine grained permissions control though an incredibly robust
policy system. Policies are written as JSON in Amazon's Access Policy Language
(APL). They can be applied directly to buckets, or indirectly through a number
of entities (users, roles, etc).

Here is an S3 policy that grants read access to anyone for a bucket:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddPerm",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::BUCKETNAME/*"]
    }
  ]
}
```

...here is another that limits access to specific IPs:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "IPDeny",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME_HERE/*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": "YOUR_CIDR_HERE"
        }
      }
    }
  ]
}
```

For more examples, [see Amazon's S3 documentation].

## EXERCISE
In this exercise you'll use Terraform to create two S3 buckets, one that hosts
a static website (provided) and another that redirects requests. You'll need to
set a liberal policy on the bucket hosting the site to ensure it can be read by
anyone on the web.

You'll know you've succeeded when you can access the static site from a web
browser either at the bucket's website endpoint, or the domain name that you
may have chosen to use.

## LEARNING OBJECTIVES

- What kind of data is good for storage on S3?
- What kinds of access levels are available for S3 data?
- How can you prevent unwanted access and manipulation of S3 data?
- How can requests for one bucket be directed to another?
- How can routed web applications be made to work on S3?
- What types of S3 buckets can Terraform define as resources?
- How do you define a bucket policy in Terraform?

[ludicrously cheap]: https://aws.amazon.com/s3/pricing/
[mitigated]: http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/custom-error-pages.html#custom-error-pages-response-code
[see Amazon's S3 documentation]: http://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html
