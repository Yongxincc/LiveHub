#!/bin/bash
set -euo pipefail
echo "Importing hmdp schema and data from /sql/hmdp.sql ..."
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" < /sql/hmdp.sql
echo "Database import finished successfully."
