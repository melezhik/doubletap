session=$(date +%s)

ls -1d templates/ 2>&1 | dtap --box - \
--session $session \
--params path=templates/ \
--check path-ok \
--desc "templates dir"

ls -1d foo/ 2>&1 | dtap --box - \
--session $session \
--params path=foo/ \
--check path-ok \
--desc "foo dir"

ls README.md 2>&1 \
| dtap --box - \
--session $session \
--params path=README.md \
--check path-ok \
--desc "readme file"

ls foo.md 2>&1 \
| dtap --box - \
--session $session \
--params path=foo.md \
--check path-ok \
--desc "foo.md file"

dtap  --report  --session $session

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures --session $session
fi
