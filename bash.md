```bash
export PATH=$PWD:$PATH

export DT_API=http://doubletap.sparrowhub.io

session=$(date +%s)

echo OK | dtap --check echo --params word=OK  --box - --session $session --desc "echo test"

ls -1d templates/ 2>&1 | dtap --box - \
--session $session \
--check directory-exists \
--desc "templates dir"

curl http://httpbin.org/foo -D - -s -o /deb/null | head -n 10  | \
dtap --box - --session $session --check web-server-ok --params fashion=gunicorn --desc "web server"

dpkg -s nano 2>&1|head -n2 | \
dtap --box - --session $session --check package-install-ok --params package=nano --desc "nano package"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures --session $session
fi
```

Output:

```
DTAP report
session: 1767605425
===
echo test ........ OK
templates dir .... OK
web server ....... FAIL
nano package ...... OK
DTAP report
session: 1767605425
===
web server ...... FAIL
[report]
12:30:28 :: [sparrowtask] - run sparrow task .@fashion=gunicorn
12:30:28 :: [sparrowtask] - run [.], thing: .@fashion=gunicorn
[task run: task.bash - .]
[task stdout]
12:30:28 :: HTTP/1.1 404 NOT FOUND
12:30:28 :: Date: Mon, 05 Jan 2026 09:30:27 GMT
12:30:28 :: Content-Type: text/html
12:30:28 :: Content-Length: 233
12:30:28 :: Connection: keep-alive
12:30:28 :: Server: gunicorn/19.9.0
12:30:28 :: Access-Control-Allow-Origin: *
12:30:28 :: Access-Control-Allow-Credentials: true
12:30:28 :: 
[task check]
stdout match <HTTP/1.1 200 OK> False
stdout match <Server: gunicorn> True
=================
TASK CHECK FAIL
2
```

To list available checks:


```bash
dtap  --check_list
```
