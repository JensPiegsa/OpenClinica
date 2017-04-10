# OpenClinica 3.13 via Docker

The [OpenClinica Community edition](https://www.openclinica.com/community-edition-open-source-edc/) is free and open source and is distributed under the [GNU LGPL license](https://www.openclinica.com/gnu-lgpl-open-source-license). 

This repository contains the *Dockerfile*, a startup script and the following instructions for running a Docker container  which you can use to give OpenClinica a try. An image built with this Dockerfile is available on [Docker Hub](https://registry.hub.docker.com/u/piegsaj/openclinica/).

> **IMPORTANT:** *This image is meant for trying out OpenClinica and not meant for running a production server or for storing important study data.*

## Setup

### 0. Install Docker

* Follow the [installation instructions](http://docs.docker.com/installation/) for your host system
* *If you are running Docker on VirtualBox:* the maximum RAM size can be adjusted through the user interface of VirtualBox (run it from the start menu, stop the virtual machine, change the configuration to e.g. 4096MB, close it and start the virtual machine using `docker-machine`)

### 1. Create a database init script

* Create a file `init-db.sh` that adds a user and a database for OpenClinica to PostgreSQL:

```sh
#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE clinica LOGIN ENCRYPTED PASSWORD 'clinica' SUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE;
    CREATE DATABASE openclinica WITH ENCODING='UTF8' OWNER=clinica;
EOSQL
```

* Please adjust the database password

### 2. Start a PostgreSQL database server

* This expects the `init-db.sh` script residing in the current directory

```sh
docker container run --name ocdb -d -v ocdb-data:/var/lib/postgresql/data \
 -v $PWD/init-db.sh:/docker-entrypoint-initdb.d/init-db.sh \
 -p 5432:5432 \
 -e POSTGRES_INITDB_ARGS="-E 'UTF-8' --locale=POSIX" \
 -e POSTGRES_PASSWORD=postgres123 \
 postgres:9.5
```

* Please change the root database password

### 3. Start Tomcat serving OpenClinica and OpenClinica-ws

```sh
docker container run --name oc -h oc -d -v oc-data:/usr/local/tomcat/openclinica.data \
 -p 80:8080 \
 -e LOG_LEVEL=INFO \
 -e TZ=UTC-1 \
 -e DB_TYPE=postgres \
 -e DB_HOST=192.168.99.100 \
 -e DB_NAME=openclinica \
 -e DB_USER=clinica \
 -e DB_PASS=clinica \
 -e DB_PORT=5432 \
 -e SUPPORT_URL="https://www.openclinica.com/community-edition-open-source-edc/" \
 piegsaj/openclinica:oc-3.13
```

* Adjust `DB_HOST` and passwords accordingly
* The environment variables for log level and timezone are optional here.

### 4. Run OpenClinica

* Open up [http://&lt;ip.of.your.host&gt;/OpenClinica](http://<ip.of.your.host>/OpenClinica) in your browser
* First time login credentials: `root` / `12345678`

## Operation

**To show the OpenClinica logs:**

```sh
docker container logs -f oc
```

**To backup a database dump to the current directory on the host:**

```
echo "postgres123" | docker container run -i --rm \
 --link ocdb:ocdb \
 -v $PWD:/tmp \
 postgres:9.5 sh -c '\
 pg_dump -h ocdb -p $OCDB_PORT_5432_TCP_PORT -U postgres -F tar -v openclinica \
 > /tmp/ocdb_pg_dump_$(date +%Y-%m-%d_%H-%M-%S).tar'
```

**To backup the OpenClinica data folder to the current directory on the host:**

```sh
docker container run --rm \
 -v oc-data:/tomcat/openclinica.data \
 -v $PWD:/tmp \
 piegsaj/openclinica:oc-3.13 \
 tar cvf /tmp/oc_data_backup_$(date +%Y-%m-%d_%H-%M-%S).tar /tomcat/openclinica.data
```

## Contribute

Feedback is welcome. The source is available on [Github](https://github.com/JensPiegsa/OpenClinica/). Please [report any issues](https://github.com/JensPiegsa/OpenClinica/issues).

