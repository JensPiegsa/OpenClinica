OpenClinica 3.4.1 via Docker
============================

This folder contains the *Dockerfile*, a startup script and the following instructions for running a Docker container  which you can use to give OpenClinica a try. An image built with this Dockerfile is available on [Docker Hub](https://registry.hub.docker.com/u/piegsaj/openclinica/).

**IMPORTANT:** *This image is meant for trying out OpenClinica and not meant for running a production server or for storing important study data.*

Steps
-----

### 1. Install Docker

* follow the [installation instructions](http://docs.docker.com/installation/) for your host system
    * **note:** with [boot2docker 1.2.0](https://github.com/boot2docker/boot2docker) the maximum RAM size can (only) be adjusted through the user interface of VirtualBox (run it from the start menu, stop the virtual machine, change the configuration to e.g. 4096MB, close it and use the desktop link "boot2docker Start")

### 2. Start the PostgreSQL database server

```sh
docker run --name ocdb -d -e POSTGRES_PASSWORD=postgres123 postgres:8
```

### 3. Initialize the database

Create database user and schemas:

```sh
docker run --link=ocdb:ocdb --rm postgres:8 sh -c 'export PGPASSWORD='postgres123' && psql -h ocdb -p "$OCDB_PORT_5432_TCP_PORT" -U postgres -c  "CREATE ROLE clinica LOGIN ENCRYPTED PASSWORD '\''clinica'\'' SUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE" && psql -h ocdb -p "$OCDB_PORT_5432_TCP_PORT" -U postgres -c "CREATE DATABASE openclinica WITH ENCODING='\''UTF8'\'' OWNER=clinica" && psql -h ocdb -p "$OCDB_PORT_5432_TCP_PORT" -U postgres -c "CREATE DATABASE \"openclinica-ws\" WITH ENCODING='\''UTF8'\'' OWNER=clinica"'
```

Allow user to connect:

```sh
docker exec ocdb sh -c 'echo "host all  clinica    0.0.0.0/0  md5" >> $PGDATA/pg_hba.conf'
docker exec ocdb su postgres -c '/usr/lib/postgresql/$PG_MAJOR/bin/pg_ctl reload -D $PGDATA'
```

### 4. Start Tomcat serving OpenClinica and OpenClinica-ws

```sh
docker run --name oc -d -p 80:8080 -e TOMCAT_PASS="admin" --link=ocdb:ocdb piegsaj/openclinica
```

### 5. Get the external IP address

* from within the virtual machine use:

```sh
ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'
```

**or** from your host system simply call if you are using boot2docker:

```sh
boot2docker ip
```


### 6. Run OpenClinica

* open up [http://&lt;ip.of.your.host&gt;/OpenClinica](http://<ip.of.your.host>/OpenClinica) in your browser
* first time login credentials: `root` / `12345678`

### Contribute

Feedback is welcome. The source is available on [Github](https://github.com/JensPiegsa/WildFly/). Please [report any issues](https://github.com/JensPiegsa/WildFly/issues).


