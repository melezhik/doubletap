export DTAP_SESSION=$(date +%s)

echo "#OK" | dtap \
--check is-commented \
--box - \
--desc "this string is commented"

dtap --report

ex_code=$?

if [[ ex_code -eq 1 ]]; then
    echo
    dtap --report --details --failures
fi
