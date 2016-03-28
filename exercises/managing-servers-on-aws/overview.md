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

When it comes time to setup larger production or stage environments the site 
[ec2instances.info] can be very helpful in selecting an instance size based 
on what your server needs most (memory, network throughput, processing 
power, storage, etc).

Because EC2 is billed based on the server's size and running time it's often 
an interesting exercise to explore the different ways a given application 
could be deployed and how that would affect the application's hosting costs. 
AWS also offers customers the ability to pay in advance for computing power 
they know they'll need in the future, which can often save money for 
deployments with long running instances.

### SECURITY GROUPS
Once you have a running instance, you need the world to be able to reach it.
Amazon provides a virtual firewall that controls traffic into and out of your
servers. You can manage this firewall by configuring security groups to limit
access via port, protocol, source and destination.

### KEYPAIRS
As you may recall from our Learn SSH class in order for a user to be given 
secure access to a server that server needs to store a copy of that user's 
public key in its `~/.ssh/authorized_keys` file. AWS allows us to create 
keypairs that can be reused across multiple instances. When spinning up a 
server Amazon will automatically configure the root user's `authorized_keys` 
file with the selected keypair's public key, on AWS Ubuntu AMIs use `ubuntu` 
as the default root user. Amazon does not store the private key and the only 
time it can be downloaded is at creation. _Don't forget to modify the key's 
permissions before trying to use it, and remember that it's in your best 
interest to set a password on this key after downloading it!_

### IAM ROLES
As we discussed in the Introduction to AWS section, IAM Roles allow servers 
access to other AWS resources without the need to bootstrap a machine with 
dedicated user credentials. Roles are assigned to the instance at creation and 
cannot be removed or edited.

## EXERCISE


## LEARNING OBJECTIVES

- Where do you find machine image ids?
- How do you decide what instance size to use?
- How do you gain root access to a new server?
- What is a firewall?
- How do you manage the firewall AWS provides?
- How do you associate roles with instances?
- Why is it desirable to associate roles with instances?

[T2]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/t2-instances.html
[ec2instances.info]: http://www.ec2instances.info/