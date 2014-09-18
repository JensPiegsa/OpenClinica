OpenClinica via Docker
======================

* with [boot2docker 1.2.0](https://github.com/boot2docker/boot2docker) the maximum RAM size can be adjusted via the user interface of **Oracle VM VirtualBox** (stop / change to e.g. 4096MB / close / boot2docker Start)
* `docker run --name ocdb -d --publish 127.0.0.1:5432:5432 postgres:9.3.5`
* `docker run --link ocdb:postgres --rm postgres:9.3.5 sh -c 'psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -c "CREATE ROLE clinica LOGIN ENCRYPTED PASSWORD '\''clinica'\'' SUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE" && exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -c "CREATE DATABASE openclinica WITH ENCODING='\''UTF8'\'' OWNER=clinica"'`
* `docker run --name oc -d -p 80:8080 -e TOMCAT_PASS="admin" --link ocdb:postgres piegsaj/openclinica`
* `ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
* open up `<ip>/OpenClinica` in your browser
* first time login credentials: `root` / `12345678`

Feedback always welcome!
