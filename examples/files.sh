session=$(date +%s)

ls -1d templates/ 2>&1 | dtap --box - \
--session $session \
--check directory-exists \
--desc "templates dir"

ls -1d foo/ 2>&1 | dtap --box - \
--session $session \
--check directory-exists \
--desc "foo dir"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    dtap --report --details --failures --session $session
fi
