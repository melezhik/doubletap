sudo lsof +c 0 -i TCP:$port -sTCP:LISTEN 2>&1 || :
