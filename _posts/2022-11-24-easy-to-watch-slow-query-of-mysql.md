# How
```sh
#!/usr/bin/bash

PASS=input_user_passowrd
HOST=db_host_domain_or_ip
SQL='SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST WHERE INFO IS NOT NULL AND INFO not like "SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST%"'
while true; do
  echo "=== $(date +"%m/%d %H:%M:%S") =====================" >> /tmp/slowquery.log
  mysql -u root -p$PASS -h $HOST -e "$SQL" >> /tmp/slowquery.log
  sleep 3
done
```