# MANAGING SERVERS ON AWS

Before we get started orchestrating servers on AWS with Terraform, we'll cover
some basics around Amazon's solution for managing virtual machines: EC2, or
Elastic Compute Cloud.

### INSTANCES & AMIs
EC2 servers, or "instances" are the fundamental building block of your server
infrastructure. Instances are created by launching Amazon Machine Images (AMI)
into a instance type of your choosing.

AMIs can be thought of as templates for a virtual server. Amazon provides AMIs
for many operating systems, e.g. Redhat, Ubuntu, Amazon Linux, or Windows. It
is also possible to provide your own machine images, but that is outside the
scope of this workshop.

Each AMI has its own unique id.
https://cloud-images.ubuntu.com/locator/ec2/

### INSTANCE SIZING
The underlying resources that an instance has access to (RAM, CPU, etc) is
mediated by the instance type. For testing, staging, development & low-volume
production, general purpose [T2] instances are appropriate and quite affordable.

Something more.

### SECURITY GROUPS
Once you have a running instance, you need the world to be able to reach it.
Amazon provides a virtual firewall that controls traffic into and out of your
servers. You can manage this firewall by configuring security groups to limit
access via port, protocol, source and destination.

### KEYPAIRS
BLAH BLAH BLAH

### IAM ROLES

## EXERCISE

There is a Terraform configuration provided with this

## LEARNING OBJECTIVES

- Where do you find machine image ids?
- How do you decide what instance size to use?
- How do you gain root access to a new server?
- What is a firewall?
- How do you manage the firewall AWS provides?
- How do you associate roles with instances?
- Why is it desirable to associate roles with instances?

[T2]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/t2-instances.html
