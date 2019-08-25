#!/bin/sh

usage(){
echo "Usage: $0 database [options]"
echo " Dumpe la base SQL fournie en paramètre, à partir du container 'mysql' (qui doit fonctionner)
       ex:  ./dumpsql.sh vtiger > /tmp/dump.sql
            ./dumpsql.sh (nom de la base) > fichier.sql"
exit 1
}
[[ $# -lt 1 ]] && usage

# Fournit le login/pass
docker-compose exec mysql sh -c 'echo "[client]\n user=vtiger\n password=pwd\n" > ~/.my.cnf'

# Invoque le client dump SQL ('mysqldump') du container 'mysql' avec les arguments
docker-compose exec mysql mysqldump $@
