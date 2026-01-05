```bash
!bash

session=$(date +%s)

echo OK | dtap --check echo --params word=OK  --box - --session $session --desc "echo test"

curl http://httpbin.org -D - -s -o /deb/null | head -n 10  | dtap --box - --session $session --check web-server-ok --params fashion=gunicorn --desc "web server"

dtap  --verbose --report  --session $session
```

Output

```
DTAP report
session: 1767596900
===
echo test ...... OK
web server ...... OK
```