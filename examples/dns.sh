session=$(date +%s)

host example.com 127.0.0.1 2>&1 | dtap --box - \
--session $session \
--params dns_host=foo.dns.x,\
dns_host_ip=10.10.13.1,\
host=foo.host.x,\
ip=10.10.17.41,\
alias=host.bar.y \
--check dns-ok \
--desc "dns foo.host.x"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures --session $session
fi
