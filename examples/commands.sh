session=$(date +%s)

(stupid-command 2>&1; echo $?) | dtap --box - \
--session $session \
--check exit-ok \
--desc "stupid command"


dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures --session $session
fi
