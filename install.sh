#!/bin/sh
rm falco-pub -rf
mkdir falco-pub
cd falco-pub
git clone https://github.com/falco-pub/vtiger-crm
git clone https://github.com/falco-pub/vtiger
docker build -t vtiger-crm:7.1.0 vtiger-crm/
cd vtiger
docker-compose up


