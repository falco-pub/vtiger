#!/bin/sh
mkdir falco-pub
pushd falco-pub
git clone https://github.com/falco-pub/vtiger-crm
git clone https://github.com/falco-pub/mysql-utf8
git clone https://github.com/falco-pub/vtiger
pushd vtiger
docker-compose up


