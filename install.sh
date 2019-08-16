#!/bin/sh
mkdir falco-pub
cd falco-pub
git clone https://github.com/falco-pub/vtiger-crm
git clone https://github.com/falco-pub/mysql-utf8
git clone https://github.com/falco-pub/vtiger
cd vtiger
docker-compose up


