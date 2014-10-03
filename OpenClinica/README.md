OpenClinica via Docker
======================

This folder contains the *Dockerfile*, a startup script and the following instructions for running a Docker container  which you can use to give OpenClinica a try. An image built with this Dockerfile is available on [Docker Hub](https://registry.hub.docker.com/u/piegsaj/openclinica/).

**IMPORTANT:** *This image is meant for trying out OpenClinica and not meant for running a production server or for storing important study data.*

Steps
-----

### 1. Install Docker

* follow the [installation instructions](http://docs.docker.com/installation/) for your host system
    * **note:** with [boot2docker 1.2.0](https://github.com/boot2docker/boot2docker) the maximum RAM size can (only) be adjusted through the user interface of VirtualBox (run it from the start menu, stop the virtual machine, change the configuration to e.g. 4096MB, close it and use the desktop link "boot2docker Start")

### 2. Start the PostgreSQL database server

```sh
docker run --name ocdb -d -p 5432:5432 postgres:9.3.5
```

### 3. Initialize the database

```sh
docker run --link ocdb:postgres --rm postgres:9.3.5 sh -c 'psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -c  "CREATE ROLE clinica LOGIN ENCRYPTED PASSWORD '\''clinica'\'' SUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE" && exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -c "CREATE DATABASE openclinica WITH ENCODING='\''UTF8'\'' OWNER=clinica"'
```

### 4. Start Tomcat serving OpenClinica

```sh
docker run --name oc -d -p 80:8080 -e TOMCAT_PASS="admin" --link ocdb:postgres piegsaj/openclinica
```

### 5. Get the external IP address

```sh
ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'
```

### 6. Run OpenClinica

* open up [http://&lt;ip.of.your.host&gt;/OpenClinica](http://<ip.of.your.host>/OpenClinica) in your browser
* first time login credentials: `root` / `12345678`

### Contribute

Feedback is welcome. The source is available on [Github](https://github.com/JensPiegsa/WildFly/). Please [report any issues](https://github.com/JensPiegsa/WildFly/issues).


