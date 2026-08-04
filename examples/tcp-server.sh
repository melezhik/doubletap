session=$(date +%s)

dtap \
--session $session \
--box tcp-server \
--check tcp-server-ok \
--params port=8080,command=nginx \
--desc "nginx binds to port 80"

dtap \
--session $session \
--box tcp-server \
--check tcp-server-ok \
--params port=9192,command=dtap_foo \
--desc "dtap_foo binds to port 9192"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures --session $session
fi
