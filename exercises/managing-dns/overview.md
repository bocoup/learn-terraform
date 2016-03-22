# MANAGING DNS

Nameservers
NS records set on registrar that set the authoritative name servers in priority order. This tells other DNS servers where to find the records for a given domain.
Record Types
A - returns an IPv4 address
AAAA - returns an IPv6 address
CNAME - alias that returns another DNS entry
MX - mail exchange record, supports priority ordering of mail servers
TXT - proving ownership of domains, metadata
TTL the amount of time a resolver should cache a response before requerying. High TTLs might be good if your DNS provider is charging a per-query price or you want to lessen the number of prefetch requests a resolver might make. In general, Low TTLs are preferred because they allow for rapid propagation and change.
Sensible Defaults/Local Overrides
Local resolvers can chose to completely ignore the TTL and cache a response as long as they would like.
Reducing before a change
If for some reason you are using a high TTL but are planning a server switch, it’s a good idea to reduce the TTL to a lower setting and waiting for your old TTL to expire before making the switch.
Modern “instant” ttl
Lots of DNS providers opt to handle additional query traffic in exchange for near instant DNS propagation. Which is generally pretty great.
Round Robin
A way to balance load across multiple servers
Resolv.conf
DNSMasq
/etc/hosts
Stage as fake prod
Dig
Specify a nameserver to check using @

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
