# echo  

Check if a text contains a string

## params 

word

## box implementation example

```
echo "hello world"
```

# web-server-ok

Check if a web server returns 200 OK, and
has a specific web server flavor

## params 

fashion

## box implementation example

```
curl http://httpbin.org -D - -s -o /deb/null | head -n 6
```

# redis-auth-ok

Check if redis protected by authentication

## params 

redis_url

## check rule

```
NOAUTH Authentication required
```

## box implementation example

```
redis-cli ping 2>&1
```

# dns-setup-ok

Check that domain server works correctly, 
by queering dns entries and checking systemd status.

For example, if following DNS configuration is set:

```
$TTL    86400 ; How long should records last?
; $TTL used for all RRs without explicit TTL value
$ORIGIN example.com. ; Define our domain name
@  1D  IN  SOA ns1.example.com. hostmaster.example.com. (
                              2024061301 ; serial
                              3h ; refresh duration
                              15 ; retry duration
                              1w ; expiry duration
                              3h ; nxdomain error ttl
                             )
       IN  NS     ns1.example.com. ; in the domain
       IN  MX  10 mail.another.com. ; external mail provider
       IN  A      172.20.0.100 ; default A record
; server host definitions
ns1    IN  A      172.20.0.100 ; name server definition
www    IN  A      172.20.0.101 ; web server definition
mail   IN  A      172.20.0.102 ; mail server definition
```

We can check such a configuration with this check rule

## params 

- dns_host
- dns_port
- name_server_ip
- web_server_ip
- mail_server_ip

## box implementation example

```
# Enable and start DNS server
sudo systemctl is-enabled knot
sudo systemctl is-active knot

# Check DNS resolution using host command
host example.com 127.0.0.1

# Check individual records using dig command
dig a @127.0.0.1 +short example.com
dig a @127.0.0.1 +short ns1.example.com
dig a @127.0.0.1 +short www.example.com
dig a @127.0.0.1 +short mail.example.com
dig mx @127.0.0.1 +short example.com
```

# path-ok

## box implementation example

```
ls foo/ 2>&1
```

# exit-ok

## box implementation example

```
(stupid-command 2>&1; echo $?)
```

