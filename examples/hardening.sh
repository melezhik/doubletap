export DTAP_SESSION=$(date +%s)

sudo systemctl is-enabled firewalld 2>&1 | dtap --box - \
--check srv-enabled \
--desc "firewalld srv is enabled"

sudo systemctl is-active firewalld 2>&1 | dtap --box - \
--check srv-active \
--desc "firewalld srv is active"

sudo firewall-cmd --list-all | dtap \
--check firewall-default-deny \
--box - \
--desc "firewall default policy is deny"

sudo sshd -T | dtap \
--check sshd-secure \
--box - \
--desc "sshd is secure"

dtap --report

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures
fi
