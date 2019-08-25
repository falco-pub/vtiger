# ![vtiger logo](https://www.vtiger.com/wp-content/uploads/2018/02/logo.png)

Vtiger CRM is open source software that helps more than 100000 businesses grow sales,  
improve marketing reach, and deliver great customer service. Try it free with Docker!

## Get started


```bash
git clone https://github.com/falco-pub/vtiger
cd vtiger
docker build -t vtiger:7.1.0 7.1.0
docker-compose up 
```

Browse to `http://{your IP}`

## Have a backup

### What vtiger needs to run correctly
 - vtiger in 'installed' state (usually in `/var/www/html/`), including:
 -- vtigercrm/storage folder, which contains user-uploaded files, like pictures
 -- optionnal additionnal modules
 - SQL database (it is populated during the installation)
        ***warning***: don't try to install vtiger with a non-empty SQL database, it will fail during installation since there already exist SQL records. In such case, export your SQL database to a dump file (see below), install vtiger on a fresh (empty) database, and load your previously created SQL dump file.


### Backup/restore the SQL base, from a running container
`./passsql.sh`  :  tells the mysql client how to connect to the server
`./dumpsql.sh vtiger > file.sql` : dump the SQL "vtiger" database into the file `file.sql`
`./restoresql.sh vtiger < file.sql` : load the SQL file `file.sql` into the "vtiger" database

### Backup/restore the storage folder (or any other subfolder), from a running container
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

### Backup/restore the storage folder, from a docker volume (the container may be shut down or even deleted)
Find the correct docker volume name : `docker volume ls`
Backup the content of the `vtiger_storage` volume to file `/tmp/storage.bz2`:
```
docker run --rm -v vtiger_storage:/vol -v /tmp:/backup alpine tar -cjf /backup/storage.bz2 -C /vol ./
```
Restore from file `/tmp/storage.bz2` to the `vtiger_storage` docker volume:
```
docker run --rm -v vtiger_storage:/vol -v /tmp:/backup alpine sh -c "tar -C /vol/ -xjf /backup/storage.bz2
```

### Perform a full backup step by step: full vtigercrm files ; storage folder ; SQL database

#### 1. vtigercrm files, including modules: about ~ 180MB
(running instance)
` docker ps`
(find the correct container name, e.g. `vtiger_vtiger_1`)
```
docker cp vtiger_vtiger_1:/var/www/html/vtigercrm vtigercrm_20190824`
```
#### 2. storage folder (docker volume) if needed, to file /tmp/storage.bz2
` docker volume ls`
(find the correct volume name, e.g. `vtiger_storage`)
```
docker run --rm -v vtiger_storage:/vol -v /tmp:/backup alpine tar -cjf /backup/storage.bz2 -C /vol ./
```
#### 3. SQL database, to file sql_20190824.sql: about 1MB
```
./passsql.sh
./dumpsql.sh vtiger > sql_20190824.sql
```

### to perform a full restore, to a fresh vtiger container

#### 1. vtigercrm files, including modules
```
mv vtigercrm_20190824 vtigercrm
docker cp vtigercrm vtiger_vtiger_1:/var/www/html/
```
#### 2. storage folder (docker volume) if needed
You ned: an archive file (tar/gz/bz2) containing the storage files, eg: `/tmp/storage.bz2`
```
docker run --rm -v vtiger_storage:/vol -v /tmp:/backup alpine sh -c "tar -C /vol/ -xjf /backup/storage.bz2
```
#### 3. SQL database
```
./passsql.sh
./restoresql.sh vtiger < sql_20190824.sql
```

### See also 

https://discussions.vtiger.com/discussion/186616/vtiger-backup-and-restore

https://loomchild.net/2017/03/26/backup-restore-docker-named-volumes/

https://docs.docker.com/storage/volumes/


