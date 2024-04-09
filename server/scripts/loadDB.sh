#!/bin/bash
#sed -i "s/utf8mb4_0900_ai_ci/utf8mb4_unicode_ci/g" dump.sql
if [ ${1: -4} == ".sql" ]; then
pv $1 | sed 's/DEFINER=[^*]*\*/\*/g' | sed 's/ROW_FORMAT=FIXED//g' | mysql $2 -u$3 -p$4
elif [ ${1: -3} == ".gz" ]; then
pv $1 | gunzip | sed 's/DEFINER=[^*]*\*/\*/g' | sed 's/ROW_FORMAT=FIXED//g' | mysql $2 -u$3 -p$4
elif [ ${1: -4} == ".bz2" ]; then
pv $1 | bunzip2 | sed 's/DEFINER=[^*]*\*/\*/g' | sed 's/ROW_FORMAT=FIXED//g' | mysql $2 -u$3 -p$4
else
echo zły format pliku
fi

mariadb backupdb
