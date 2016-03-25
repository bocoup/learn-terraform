# MANAGING STATIC FILE STORAGE
Most cloud providers offer some form of scalable flat file storage but for 
this section we're primarily going to focus on Amazon S3, though many of 
these concepts are valid across providers.

## What is S3
S3 stands for Simple Storage Service and is Amazon's pay per use storage 
solution for static files. In addition to being ludicrously cheap it offers 
fine grained permissions control, making it appropriate for a range of uses. 

S3 bucket names are globally unique, and the storage they provide is flat; 
meaning that even though several visual S3 browsers give the appearance of 
buckets containing folders, in actuality the "full path" to a resource on S3 is
no more than a string based key for the resource.

### Private Buckets
A private S3 bucket is the appropriate place to store data that your application 
collects from users or otherwise needs to load from an external source in order
to function. The environment your application runs in will determine how you 
can authenticate to the bucket. As we learned in the Introduction to AWS 
section, roles can be assigned to EC2 servers that allow them to communicate 
with other intra-AWS resources without the need for credentials. 
Alternatively AWS offers SDK's for several development environments that allow 
your application to securely communicate with private S3 buckets.  

### Web Hosting Buckets
Since S3 stores static files it's no surprise that many folks utilize it for 
cost effective web hosting. S3 buckets can be configured for "static website 
hosting" which will allow the bucket owner to set an index document, an error
document, and simple redirection rules.  In order for an S3 bucket to host a 
site the bucket name must match the domain name, so to host the site 
`www.wakawaka.com` the bucket name would have to be `www.wakawaka.com`. 

If you're hosting a static single page application that uses a router and a 
single `index.html` file, it's likely you'll have to set your error document to
the same resource as your index document and let the router handle displaying
the error page. The downside to this is that your site will not return the `200` 
http code for routed requests, though this can be [mitigated] by using 
Cloudfront, Amazon's CDN.

You can wire up DNS to a bucket by setting a `CNAME` record to the bucket's
`website_endpoint` value.

### Redirect Buckets
Because web hosting buckets can only respond to requests from domains that 
match the bucket name that makes dealing with multiple subdomains or root 
domains a bit of a challenge. Fortunately S3 supports a redirect mode that 
allows requests for subdomains to be appropriately routed. In the case where 
you wanted your site to mainly be accessed at `www.yoursite.com` and requests
for `yoursite.com` to be redirected to `www` you'd setup the `www.yoursite.com` 
bucket with all your site content and setup a `yoursite.com` bucket as a 
redirect bucket that should send all traffic to the `www.yoursite.com` bucket.

### S3 Policies
As mentioned S3 buckets have many fine grained permissions control options. 
Aside from role based access, buckets can have policies attached to them that
specify how requests should be handled and from where and who those requests 
should be allowed. These policies are written as JSON in Amazon's Access 
Policy Language (APL). Here is an example of an S3 policy that grants read 
access to anyone for a bucket:

```
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::BUCKETNAME/*"]
    }
  ]
}
```

## EXERCISE
In this exercise you'll use terraform to setup two S3 buckets, one that hosts
a static website (provided) and another that redirects requests. You'll need to 
set a liberal policy on the bucket hosting the site to ensure it can be read by 
anyone on the web. Optionally, if you have a domain or want to buy one you 
can wire up DNS as well.

You'll know you've succeeded when you can access the static site from a web 
browser either at the bucket's website endpoint or the domain name that you may
have chosen to use.

## LEARNING OBJECTIVES

- What kind of data is good for storage on S3?
- What kinds of access levels are available for S3 data?
- How can you prevent unwanted access and manipulation of S3 data?
- How can requests for one bucket be directed to another?
- How can routed web applications be made to work on S3?
- What types of S3 buckets can Terraform define as resources?
- How do you define a bucket policy in Terraform?

[mitigated]: http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/custom-error-pages.html#custom-error-pages-response-code