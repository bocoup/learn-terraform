# MANAGING DNS
The Domain Name System is _the_ decentralized directory service for IP based
networks. It's like a phone book for the internet (or your intranet). Servers
spread across the world share information that help computers find each other
by mapping human readable domain names to useful pieces of data, like IP
addresses. Thanks to DNS, we don't have to memorize the IP address of every
service we connect to!

## NS RECORDS
When you purchase a domain from a registrar, it comes with a set of DNS entries
by default: the nameserver (NS) records. These records are maintained by the
registrar and they are responsible for telling the global DNS network what
server(s) should be the source of truth for all other DNS records on your
domain.

Typically, a registrar will assign nameservers that are managed by the registrar
itself. It's a good practice to use dedicated DNS providers like Cloudflare,
Amazon Route53, etc. These purpose-built services typically allow API access to
the configuration, making it easier to manage with tooling like Terraform and
Ansible. Additionally, having your nameservers decoupled from your registrar
makes it easier to transfer to a new registrar should the need arise.

## NAMESERVERS / DNS SERVERS
A nameserver is a server with DNS software installed on it. DNS software is
responsible for storing information about a domain and making it accessible to
the world. There are several types of DNS records but we're going to focus on
the 5 you're most likely encounter.

## Record Types

#### A
An IPv4 address record.

#### AAAA
an IPv6 address record.

#### CNAME
An alias to another DNS record.

#### MX
A mail exchange record, specifying what server(s) should handle email that
needs to be routed for this domain. If multiple servers are available, they
can be listed in priority order.

#### TXT
General metadata storage records. Often used for proving ownership of domains
(a third party says, put this value into your records and we know you own the
domain when I can query for the expected result).

## TTL
Each DNS record has a "time to live" configuration. This represents the number
of seconds a record should be cached by machines that ask for it. Low TTLs are
generally preferred as fast propagation of changes is typically desirable. High
TTLs *might* be good if your DNS provider charges based on the number requests.

In practice, DNS resolvers may choose to ignore a record's TTL value completely,
caching based on their own configuration!

## Round Robin
DNS can be used to provide service load balancing by setting multiple records
of the same type and key to different values. When requests come in, the DNS
software running on the nameserver will rotate through the entries, responding
to requests with an even distribution of the available options for a given
query.

## /etc/resolv.conf
On Linux machines this file contains a newline delimited priority ordered list
of DNS server IP addresses that your machine will contact to try and resolve
record data for domain names.

## /etc/hosts
On most modern operating systems (Windows excepted), this file contains a
newline delimited list of IP addresses followed by the domain name(s) that
should be associated with them.

If a domain is listed in this file your machine will not call out to the DNS
servers listed in `/etc/resolv.conf` and will instead be routed to the defined
IP address.

This is particularly useful when testing with a local virtual machine or a
remote staging environment that is configured EXACTLY like production; meaning
that the server will not even respond to a request unless it comes in with the
production domain name.

Permission elevation is required to edit this file, and the changes take effect
immediately. An `/etc/hosts` entry looks like this:

```
127.0.0.1 wakawaka.com
```

It should be noted that `/etc/hosts` does not support wildcards or service
ports, if you need more fine grained control, you'll have to locally install a
real DNS server like [DNSMasq], configure it as needed, and add the loop back
IP address (`127.0.0.1`) as the first entry in `/etc/resolv.conf`.

## Dig
You can use the dig command to look up the DNS entries and their TTLs for any
domain name.

```
dig google.com
```

By default dig returns a single `A` record from the nameservers that are
configured in your machine's `/etc/resolv.conf` file. But you can ask dig to
query another nameserver, like an OpenDNS server with the IP `208.67.222.222`:

```
dig @208.67.222.222 google.com
```

or to list records of a different type:

```
dig @208.67.222.222 google.com mx
```

You can even check the configured nameservers:

```
dig google.com ns
```

Dig will always ask a real DNS server for record data and will not reflect
any configuration residing in `/etc/hosts`.

## EXERCISE
In this exercise you'll experiment with `/etc/hosts` by redirecting requests
for `google.com` to `duckduckgo.com`. To accomplish this task you'll have to
use `dig` to determine what value to set in `/etc/hosts`.

You'll know you've succeeded when you try to access `google.com` in a browser
and are automatically redirected to `duckduckgo.com`. Don't forget to update
`/etc/hosts` back to it's initial state after this exercise is complete!

## LEARNING OBJECTIVES

- What are nameservers?
- How can services validate who controls a domain?
- What is TTL and how is it used by resolvers?
- How can DNS help with load balancing?
- How can we fake DNS on our local machines?
- How do our local machines know which DNS server to communicate with?
- How can we find out what DNS records exist on a domain?
- How do you manage DNS entries as terraform resources?

[DNSMasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
