# web server check

```bash
curl http://httpbin.org/foo -D - -s -o /dev/null | head -n 10  | \
dtap \
--box - \
--session $session \
--check web-server-ok \
--params fashion=gunicorn \
--desc "web server"
```

# package install check

```bash
dpkg -s nano 2>&1|head -n2 | \
dtap \
--box - \
--session $session \
--check package-install-ok \
--params package=nano \
--desc "nano package"
```

# file and directory exists check

```bash
ls -1d templates/ 2>&1 | dtap --box - \
--session $session \
--params path=templates/ \
--check path-ok \
--desc "templates dir"

ls README.md 2>&1 \
| dtap --box - \
--session $session \
--params path=README.md \
--check path-ok \
--desc "readme file"
```

# service enabled and running

```bash
sudo systemctl is-enabled nginx 2>&1 | dtap --box - \
--session $session \
--check srv-enabled \
--desc "nginx srv enable"


sudo systemctl is-active nginx 2>&1 | dtap --box - \
--session $session \
--check srv-active \
--desc "nginx srv active"
```

# dns server has entry

```bash
host example.com 127.0.0.1 2>&1 | dtap --box - \
--session $session \
--params path=dns_host=127.0.0.1,dns_port=53,ip=172.20.0.100,host=example.com \
--check dns-ok \
--desc "dns example.com"
```

# command exits successfully

```bash
(sudo service nginx reload 2>&1; echo $?) | dtap --box - \
--session $session \
--check exit-ok \
--desc "nginx reload"
```
