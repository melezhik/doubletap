export DTAP_SESSION=$(date +%s)

dpkg -s nano 2>&1 | dtap \
--check package-install-ok \
--box - \
--params pm=dpkg \
--desc "nano package is installed"

dpkg -s nginx 2>&1 | dtap \
--check package-install-ok \
--box - \
--params pm=dpkg \
--desc "nginx package is installed"

sudo systemctl is-active nginx 2>&1 | dtap \
--check srv-active \
--box - \
--desc "nginx srv is active"

dtap --report

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures
fi
