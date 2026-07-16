session=$(date +%s)

sudo firewall-cmd --state | dtap \
--check firewall-default-deny \
--box - \
--session $session \
--desc "firewall default policy is deny"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures --session $session
fi
