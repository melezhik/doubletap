session=$(date +%s)

sudo systemctl is-enabled firewalld 2>&1 | dtap --box - \
--session $session \
--check srv-enabled \
--desc "firewalld srv enable"


sudo systemctl is-active firewalld 2>&1 | dtap --box - \
--session $session \
--check srv-active \
--desc "firewalld srv active"

sudo firewall-cmd --list-all | dtap \
--check firewall-default-deny \
--box - \
--session $session \
--desc "firewall default policy is deny"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures --session $session
fi
