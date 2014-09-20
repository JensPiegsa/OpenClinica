#!/bin/bash
if [ ! -f /.tomcat_admin_created ]; then
  /create_tomcat_admin_user.sh
fi

sed -i "/^dbHost=.*/c\dbHost=$POSTGRES_PORT_5432_TCP_ADDR" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^dbPort=.*/c\dbPort=$POSTGRES_PORT_5432_TCP_PORT" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties

exec ${CATALINA_HOME}/bin/catalina.sh run
