# echo  

Check if a text contains a string

## params 

word

## box implementation example

```
echo "hello world"
```

# package-install-ok

Check if package is installed

## params

package

## box implimentation example

```
dpkg -s nano 2>&1|head -n2
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

## box implementation example

```
redis-cli ping 2>&1
```

# path-ok

Check that file or directory exists

## box implementation example

```
ls foo/ 2>&1
```

# exit-ok

Check that command succeeds

## box implementation example

```
(stupid-command 2>&1; echo $?)
```

# srv-active

Check that service is running

## box implementation example

```
sudo systemctl is-active knot 2>&1
```

# srv-enabled

Check that service is enabled

## box implementation example

```
sudo systemctl is-enabled knot 2>&1
```

# dns-ok

Check that dns server has host entry

## params

`dns_host=string,dns_port=int,host=string,ip=string`

## box implementation example

```
host example.com 127.0.0.1 2>&1
```
