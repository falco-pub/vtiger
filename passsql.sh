#!/bin/sh

# Fournit le login/pass au client SQL sur le container
echo "trying to pass the .my.cnf file to container 'mysql'"
docker-compose exec mysql sh -c 'echo "[client]\n user=vtiger\n password=pwd\n" > ~/.my.cnf'
