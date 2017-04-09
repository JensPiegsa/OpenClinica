#!/bin/bash

PROPS="${CATALINA_HOME}/webapps/OpenClinica/WEB-INF/classes/datainfo.properties"

sed -i "/^dbType=.*/c\dbType=$DB_TYPE" ${PROPS}
sed -i "/^dbUser=.*/c\dbUser=$DB_USER" ${PROPS}
sed -i "/^dbPass=.*/c\dbPass=$DB_PASS" ${PROPS}
sed -i "/^dbHost=.*/c\dbHost=$DB_HOST" ${PROPS}
sed -i "/^db=.*/c\db=$DB_NAME" ${PROPS}
sed -i "/^dbPort=.*/c\dbPort=$DB_PORT" ${PROPS}
sed -i "/^userAccountNotification=.*/c\userAccountNotification=admin" ${PROPS}
sed -i "/^# about\.text1=.*/c\about.text1= Powered by" ${PROPS}
sed -i "/^# about\.text2=.*/c\about.text2= mosaic-greifswald.de" ${PROPS}
sed -i "/^# supportURL=.*/c\supportURL=$SUPPORT_URL" ${PROPS}
sed -i "/^collectStats=.*/c\collectStats=false" ${PROPS}
sed -i "/^designerURL=.*/c\designerURL=" ${PROPS}

cp ${PROPS} ${CATALINA_HOME}/webapps/OpenClinica-ws/WEB-INF/classes/

OC_LOG_PROPS="${CATALINA_HOME}/webapps/OpenClinica/WEB-INF/classes/logging.properties"
WS_LOG_PROPS="${CATALINA_HOME}/webapps/OpenClinica-ws/WEB-INF/classes/logging.properties"

if [ -z "$LOG_LEVEL" ]; then
  echo "Using default log level."
else
  echo "org.apache.catalina.core.ContainerBase.[Catalina].level = $LOG_LEVEL" > ${OC_LOG_PROPS}
  echo "org.apache.catalina.core.ContainerBase.[Catalina].handlers = java.util.logging.ConsoleHandler" >> ${OC_LOG_PROPS}
  echo "org.apache.catalina.core.ContainerBase.[Catalina].level = $LOG_LEVEL" > ${WS_LOG_PROPS}
  echo "org.apache.catalina.core.ContainerBase.[Catalina].handlers = java.util.logging.ConsoleHandler" >> ${WS_LOG_PROPS}
fi

exec ${CATALINA_HOME}/bin/catalina.sh run
