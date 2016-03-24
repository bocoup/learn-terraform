
## Get the IP of DuckDuckGo

`dig duckduckgo.com`

**output:**

```
; <<>> DiG 9.8.3-P1 <<>> duckduckgo.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 4355
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;duckduckgo.com.			IN	A

;; ANSWER SECTION:
duckduckgo.com.		15	IN	A	50.18.192.251
duckduckgo.com.		15	IN	A	50.18.192.250
duckduckgo.com.		15	IN	A	54.215.176.19

;; Query time: 73 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Thu Mar 24 13:22:00 2016
;; MSG SIZE  rcvd: 80
```
## Select one of the IP's listed as A record values.

## Edit `/etc/hosts`
`sudo nano /etc/hosts`

## Add configuration to send requests bound for google.com to a specific IP

```
50.18.192.251 google.com
```

_Don't forget to save the file!_
