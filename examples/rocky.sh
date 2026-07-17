export DTAP_SESSION=$(date +%s)

rpm -q nano 2>&1 | dtap \
--check package-install-ok \
--box - \
--params pm=rpm \
--desc "nano package is installed"

dtap --report

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures
fi
