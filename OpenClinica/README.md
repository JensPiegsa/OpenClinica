OpenClinica via Docker
======================

This folder contains the *Dockerfile*, a startup script and the following instructions for running a Docker container  which you can use to give OpenClinica a try. An image built with this Dockerfile is available on [Docker Hub](https://registry.hub.docker.com/u/piegsaj/openclinica/).

**IMPORTANT:** *This image is meant for trying out OpenClinica and not meant for running a production server or for storing important study data.*

Steps
-----

#### 1. Increase available memory

> With [boot2docker 1.2.0](https://github.com/boot2docker/boot2docker) the maximum RAM size can be adjusted through the user interface of **Oracle VM VirtualBox** (stop it / change to e.g. 4096MB / close VirtualBox / boot2docker Start).

#### 2. Start PostgreSQL server

```sh
docker run --name ocdb -d -p 5432:5432 postgres:9.3.5
docker run --link ocdb:postgres --rm postgres:9.3.5 sh -c 'psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -c  "CREATE ROLE clinica LOGIN ENCRYPTED PASSWORD '\''clinica'\'' SUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE" && exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -c "CREATE DATABASE openclinica WITH ENCODING='\''UTF8'\'' OWNER=clinica"'
```

#### 3. Start Tomcat server with OpenClinica

```sh
docker run --name oc -d -p 80:8080 -e TOMCAT_PASS="admin" --link ocdb:postgres piegsaj/openclinica
```

#### 4. Show external IP address

```sh
ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'
```

#### 5. Run OpenClinica

* open up `<ip>/OpenClinica` in your browser
* first time login credentials: `root` / `12345678`

*Feedback is welcome.*
