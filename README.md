# ![vtiger logo](https://www.vtiger.com/wp-content/uploads/2018/02/logo.png)

Vtiger CRM is open source software that helps more than 100000 businesses grow sales,  
improve marketing reach, and deliver great customer service. Try it free with Docker!

## Get started

### Step.0
```bash
git clone https://github.com/falco-pub/vtiger
cd vtiger
docker build -t vtiger:7.1.0 7.1.0
docker-compose up 
```
The docker-compose file calls two persistent docker volumes :

 - `mysql` (bound to /var/lib/mysql/ in the `mysql` container).

 -- see **Step1.2** and **Step2.2** for how to properly backup and restore mysql database.
 - `crm` (bound to /var/www/html/vtigercrm/ in the `vtiger` container):

 -- see **Step1.1** and **Step2.1** for how to backup and restore that folder.

Browse to `http://{your IP}`

## Have a backup

### What vtiger needs to run correctly
 - vtiger in 'installed' state (usually in `/var/www/html/`), including:

 -- `vtigercrm/storage` folder, which contains user-uploaded files, like pictures

 -- optionnal additionnal modules

 - SQL database (it is populated during the installation)
        ***warning***: don't try to install vtiger with a non-empty SQL database, it will fail during installation since there already exist SQL records. In such case, export your SQL database to a dump file (see below, **Step1.2**), install vtiger on a fresh (empty) database (**Step0**), and load your previously created SQL dump file (**Step2.2**).


### Backup/restore the SQL base, from a running container
`./passsql.sh`  :  tells the mysql client how to connect to the server
`./dumpsql.sh vtiger > file.sql` : dump the SQL "vtiger" database into the file `file.sql`
`./restoresql.sh vtiger < file.sql` : load the SQL file `file.sql` into the "vtiger" database

### Backup/restore the vtigercrm/storage subfolder (or any other subfolder), from a running container
Backup the `storage` folder from the `vtiger_vtiger_1` container, to the directory named `storage_backup_20190824`:
```
docker ps
docker cp vtiger_vtiger_1:/var/www/html/vtigercrm/storage storage_backup_20190824
```
To restore (be sure of the right folder name):
```
mv storage_backup_20190824 storage
docker cp storage vtiger_vtiger_1:/var/www/html/vtigercrm
```

### Backup/restore the `vtigercrm` folder, from a running container
Backup the `vtigercrm` folder from the `vtiger_vtiger_1` container, to the directory named `vtigercrm_backup_20190824`:
```
docker ps
docker cp vtiger_vtiger_1:/var/www/html/vtigercrm vtigercrm_backup_20190824
```
To restore (be sure of the right folder name):
```
mv vtigercrm_backup_20190824 vtigercrm
docker cp vtigercrm vtiger_vtiger_1:/var/www/html/vtigercrm
```


### Backup/restore the content of a docker volume (the container may be shut down or even deleted)
Find the correct docker volume name : `docker volume ls`, eg: `vtiger_crm`

Backup the content of the `vtiger_crm` volume to file `/tmp/crm.bz2`:
```
docker run --rm -v vtiger_crm:/vol -v /tmp:/backup alpine tar -cjf /backup/crm.bz2 -C /vol ./
```
Restore from file `/tmp/crm.bz2` to the `vtiger_crm` docker volume:
```
docker run --rm -v vtiger_crm:/vol -v /tmp:/backup alpine sh -c "tar -C /vol/ -xjf /backup/crm.bz2
```

### Perform a full backup: full vtigercrm files ; SQL database

#### Step1.1. vtigercrm files, including modules and storage: about ~ 180MB
(running instance)
` docker ps`
(find the correct container name, e.g. `vtiger_vtiger_1`)
```
docker cp vtiger_vtiger_1:/var/www/html/vtigercrm vtigercrm_20190824`
```

You can also copy the /var/lib/mysql folder from the `mysql` container:
```
docker cp vtiger_mysql_1:/var/lib/mysql mysql_20190824
```

#### Step1.2. SQL database, to file sql_20190824.sql: about 1MB
```
./passsql.sh
./dumpsql.sh vtiger > sql_20190824.sql
```

### Full restore, to a fresh-new vtiger container

#### See **step0** for how to start a new vtiger container

#### Step2.1. vtigercrm files, including modules and storage
```
mv vtigercrm_20190824 vtigercrm
docker cp vtigercrm vtiger_vtiger_1:/var/www/html/
```

You can also restore the mysql folder into /var/lib/mysql of the `mysql` container:
```
docker cp mysql vtiger_mysql_1:/var/lib/mysql
```
#### Step2.2. SQL database
```
./passsql.sh
./restoresql.sh vtiger < sql_20190824.sql
```

### See also 

https://discussions.vtiger.com/discussion/186616/vtiger-backup-and-restore

https://loomchild.net/2017/03/26/backup-restore-docker-named-volumes/

https://docs.docker.com/storage/volumes/


