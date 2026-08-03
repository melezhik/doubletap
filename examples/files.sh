export DTAP_SESSION=$(date +%s)

ls -1d templates/ 2>&1 | dtap --box - \
--params path=boxes/ \
--check path-ok \
--desc "boxes dir"

ls -1d foo/ 2>&1 | dtap --box - \
--params path=foo/ \
--check path-ok \
--desc "foo dir"

ls README.md 2>&1 \
| dtap --box - \
--params path=README.md \
--check path-ok \
--desc "readme file"

if [[ "$(uname)" == "Darwin" ]]; then
  stat -f %A README.md 2>&1 \
    | dtap --box - \
    --params perm=777 \
    --check perm-ok \
    --desc "readme perm 777"
else
  stat -c %a README.md 2>&1 \
    | dtap --box - \
    --params perm=777 \
    --check perm-ok \
    --desc "readme perm 777"
fi

ls foo.md 2>&1 \
| dtap --box - \
--params path=foo.md \
--check path-ok \
--desc "foo.md file"

dtap  --report

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures
fi
