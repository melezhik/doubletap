session=$(date +%s)

host example.com 127.0.0.1 2>&1 | dtap --box - \
--session $session \
--params path=dns_host=127.0.0.1,dns_port=53,ip=172.20.0.100,host=example.com \
--check dns-ok \
--desc "dns example.com"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures --session $session
fi
