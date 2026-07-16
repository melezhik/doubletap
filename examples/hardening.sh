session=$(date +%s)

sudo firewall-cmd --state | dtap \
--check firewall-default-deny \
--box - \
--session $session \
--desc "firewall default policy is deny"
