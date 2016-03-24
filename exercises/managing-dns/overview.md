# MANAGING DNS
The Domain Name System is _the_ decentralized directory service for IP based 
networks. It's like a phone book for the internet (or your intranet). Servers
spread across the world share information that helps computers find each 
other by mapping human readable domain names to useful pieces of data like 
the IP address of the particular machine. If it weren't for DNS we'd have to 
memorize the IP address of every website we connected to (or at least an IP 
based search engine).

## Nameserver Records
Nameserver records, or NS records are maintained by a domain's registrar and 
are responsible for telling the global DNS network which server(s) should 
be the source of truth for the remainder of a domain's DNS records. By 
default registrars will set your NS records to point to their own nameservers
but it's generally a good idea to use a distinct nameserver provider to 
facilitate ease of registrar transfer and choice at purchase time.

## Nameserver(s)
A nameserver is responsible for storing information about a given domain, 
this information can be queried and cached by the global network of DNS 
servers which enable our global internet. There are several types of DNS 
records but we're going to focus on the 5 you're most likely encounter.

## Record Types
  - **A**: returns an IPv4 address
  - **AAAA**: returns an IPv6 address
  - **CNAME**: alias that returns another DNS entry
  - **MX**: mail exchange record, supports priority ordering of mail servers 
  to handle email that needs to be routed for this domain
  - **TXT**: proving ownership of domains by assigning to a known value or 
  otherwise storing general metadata

## TTL 
Each record can have a time to live configured which represents the amount of
time in seconds that the value of that record should be cached by machines 
that ask for it. High TTLs might be good if your DNS provider charges based 
on the number of requests received or if you want to ensure changes to a 
domain take a long time to propagate globally. Generally though, Low TTLs are
preffered since more often than not fast global propagation is desirable. 
Most third party DNS providers that don't charge per query offer near 
instant propagation by defaulting to very low TTLs. In practice, resolvers may
choose to ignore a record's TTL value completely and cache based on their own
configuration.

## Round Robin
DNS can be used to provide service load balancing by setting multiple records
of the same type. When requests come in for a given record the name server 
will choose evenly from what is available or evenly within priority group order
if supported by the record type.

## /etc/resolv.conf
On Linux machines this file contains a list of DNS server IP addresses that 
your machine will contact to try and resolve record data for domain names.

## /etc/hosts
On Linux and Linux based machines this file contains a new line delimited 
list of IP addresses followed by the domain name(s) that should be associated 
with them. If a domain is listed in this file your machine will not call out 
to the DNS servers listed in `/etc/resolv.conf` and will instead be routed to
the associated IP address. This is particularly useful when testing with a 
local virtual machine or a remote staging environment that is configured 
EXACTLY like production; meaning that the server will not even respond to a  
request unless it comes in with the production domain name.

## Dig
You can use the dig command to look up the DNS entries for any domain name. 

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

## EXERCISE


## LEARNING OBJECTIVES

- What are nameservers?
- How can services validate who controls a domain?
- What is TTL and how is it used by resolvers?
- How can DNS help with load balancing?
- How can we fake DNS on our local machines?
- How do our local machines know which DNS server to communicate with?
- How can we find out what DNS records exist on a domain?
- How do you manage DNS entries as terraform resources?
