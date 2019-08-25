#!/bin/sh

usage(){
echo "Usage: $0 database [options]"
echo " Restaure le dump SQL dans la base fournie en paramètre (le container 'mysql' contenant le serveur SQL doit fonctionner)
       ex:  ./restoresql.sh vtiger < /tmp/dump.sql
            ./restoresql.sh (nom de la base) < fichier.sql"
exit 1
}
[[ $# -lt 1 ]] && usage

# Invoque le client SQL ('mysql') du container 'mysql' avec les arguments
docker-compose exec -T mysql mysql $@
