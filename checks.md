# echo  

Check if a text contains a string

## params 

word

## box input

```
echo "hello world"
```

# package-install-ok

Check if package is installed

## params

pm

Package manager. Default is `dpkg`. Supported values are `dpkg|rpm`

## box input

```
# debian based
dpkg -s nano 2>&1|head -n2

# centos based
rpm -q nano 2>&1
``` 

# web-server-ok

Check if a web server returns 200 OK, and
has a specific web server header (fashion)

## params 

fashion

Checks if a server reply has "Server: $fashion" http header. For example `fashion=nginx`

## box input

```
curl http://httpbin.org -D - -s -o /deb/null | head -n 6
```

# redis-auth-ok

Check if redis protected by authentication

## params 

redis_url

## box input

```
redis-cli ping 2>&1
```

# path-ok

Check that file or directory exists

## box input

```
ls foo/ 2>&1
```

# exit-ok

Check that command succeeds

## box input

```
(stupid-command 2>&1; echo $?)
```

# srv-active

Check that service is running

## box input

```
sudo systemctl is-active knot 2>&1
```

# srv-enabled

Check that service is enabled

## box input

```
sudo systemctl is-enabled knot 2>&1
```

# dns-ok

Check that dns server has host entry

## params

`dns_host=string,dns_port=int,host=string,ip=string`

## box input

```
host example.com 127.0.0.1 2>&1
```

# perm-ok

Check directory/file permission

## params

`perm=int`

## box input

```
# Mac OS

stat -f %A README.md 2>&1

# Linux
stat -c "%a" README.md
```

# firewall-default-deny

Check if firewall default policy is set to deny

## box input

```
sudo firewall-cmd --list-all
```

# selinux-enabled

Check if selinux is enabled

## box input

```
getenforce
```

# selinux-config-ok

Check if selinux is enforced via configuration file 

## box input

```
cat /etc/selinux/config
```

# sshd-secure

Check if sshd has secure setup

## box input

```
sudo sshd -T
```

# tcp-server-ok

Check if a command/proccess binds to tcp port

## box input

see tcp-server box 

## params

command

Command/procces that is expected to bind to a port

