session=$(date +%s)

sudo systemctl is-enabled knot 2>&1 | dtap --box - \
--session $session \
--check srv-enabled \
--desc "knot srv enable"


sudo systemctl is-active knot 2>&1 | dtap --box - \
--session $session \
--check srv-active \
--desc "knot srv active"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures --session $session
fi
