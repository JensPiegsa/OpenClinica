#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
  /create_tomcat_admin_user.sh
fi

sed -i "/^dbHost=.*/c\dbHost=ocdb" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^dbPort=.*/c\dbPort=$OCDB_PORT_5432_TCP_PORT" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^userAccountNotification=.*/c\userAccountNotification=admin" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# rssUrl=.*/c\rssUrl=" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# rssMore=.*/c\rssMore=" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# about\.text1=.*/c\about.text1=Powered by <a href=\"https://mosaic-greifswald.de\">mosaic-greifswald.de</a>" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# about\.text2=.*/c\about.text2=<a href=\"https://mosaic-greifswald.de/das-mosaic-projekt/aktuelles\">Aktuelles</a>" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^# supportURL=.*/c\supportURL=https://mosaic-greifswald.de/openclinica" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^collectStats=.*/c\collectStats=false" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
sed -i "/^designerURL=.*/c\designerURL=" /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties
cp /tomcat/webapps/OpenClinica/WEB-INF/classes/datainfo.properties /tomcat/webapps/OpenClinica-ws/WEB-INF/classes/

if [ -z "$LOG_LEVEL" ]; then
  echo "Using default log level."
else
  echo "org.apache.catalina.core.ContainerBase.[Catalina].level = $LOG_LEVEL" > /tomcat/webapps/OpenClinica/WEB-INF/classes/logging.properties
  echo "org.apache.catalina.core.ContainerBase.[Catalina].handlers = java.util.logging.ConsoleHandler" >> /tomcat/webapps/OpenClinica/WEB-INF/classes/logging.properties
  echo "org.apache.catalina.core.ContainerBase.[Catalina].level = $LOG_LEVEL" > /tomcat/webapps/OpenClinica-ws/WEB-INF/classes/logging.properties
  echo "org.apache.catalina.core.ContainerBase.[Catalina].handlers = java.util.logging.ConsoleHandler" >> /tomcat/webapps/OpenClinica-ws/WEB-INF/classes/logging.properties
fi  

exec ${CATALINA_HOME}/bin/catalina.sh run
