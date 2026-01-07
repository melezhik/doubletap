export PATH=$PWD:$PATH

export DT_API=http://doubletap.sparrowhub.io

session=$(date +%s)

echo OK | dtap \
--check echo \
--params word=OK  \
--box - \
--session $session \
--desc "echo test"

curl http://httpbin.org/foo -D - -s -o /dev/null | head -n 10  | \
dtap \
--box - \
--session $session \
--check web-server-ok \
--params fashion=gunicorn \
--desc "web server"

dpkg -s nano 2>&1|head -n2 | \
dtap \
--box - \
--session $session \
--check package-install-ok \
--params package=nano \
--desc "nano package"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures --session $session
fi
