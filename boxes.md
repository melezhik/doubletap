# echo  

Check if text contains a string

## check_id

echo

## params 

word

## box implementation example

```
echo "hello world"
```

# web server

Check if a web server returns 200 OK, and
has a specific web server flavour

## check_id

web-server-ok

## params 

fashion

## box implementation example

```
curl http://httpbin.org -D - -s -o /deb/null | head -n 6
```

# redis authentication 

Check if redis protected by authentication

## box_id

redis-auth

## check_id

redis-auth-ok

## params 

redis_url

## check rule

```
NOAUTH Authentication required
```

## box implementation example

```
redis-cli ping 2>&1 || :
```

# domain name server

Check that domain server works correctly,
by queering dns entries and checking
systemd status.

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

We can check such a configuration with following check rule

## box_id

dns-setup

## check_id

dns-setup-ok

## params 

- host
- port

## check rule

```
note: Check that service is enabled and active
begin:
    # server should be enabled
    enabled
    # server should be active
    active
end:

note: Check DNS resolution using host command
begin:
    Using domain server:
    Name: 127.0.0.1
    Address: 127.0.0.1
    Aliases:
    regexp: ^^  $$
    example.com has address 172.20.0.100
    example.com mail is handled by 10 mail.another.com.
end:


note: Check individual records using dig command
begin:
    172.20.0.100
    172.20.0.100
    172.20.0.101
    172.20.0.102
    10 mail.another.com.
end:
```

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

# ssh login attempts

Find unsuccessful login attempts and return
all found logins.

## box_id

ssh-log

## check_id

ssh-login-attempt

## check rule

```
~regexp: "Failed password for" \s+ (\S+) \s+ from

code: <<stat
!raku
my @data;
for captures()<> -> $i {
   push @data, $i.head;
}
update_state(%( data => $data ));
stat
```

## box implementation example

```
sudo cat /var/log/auth.log
```
