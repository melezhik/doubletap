export PATH=$PWD:$PATH

export DT_API=http://doubletap.sparrowhub.io

session=$(date +%s)

echo OK | dtap --check echo --params word=OK  --box - --session $session --desc "echo test"

curl http://httpbin.org/foo -D - -s -o /deb/null | head -n 10  | dtap --box - --session $session --check web-server-ok --params fashion=gunicorn --desc "web server"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures --session $session
fi