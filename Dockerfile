# Dockerfile for OpenClinica
#
# - for testing purposes only
# - needs an additional postgres container

FROM tomcat:7.0-jre8

MAINTAINER Jens Piegsa (piegsa@gmail.com)

ENV  OC_HOME              $CATALINA_HOME/webapps/OpenClinica
ENV  OC_WS_HOME           $CATALINA_HOME/webapps/OpenClinica-ws

ENV  OC_VERSION           3.13

COPY run.sh               /run.sh

RUN  mkdir /tmp/oc && \
     cd /tmp/oc && \

     wget -q --no-check-certificate -Oopenclinica.zip http://www2.openclinica.com/l/5352/2017-03-02/51xd3y && \
     wget -q --no-check-certificate -Oopenclinica-ws.zip http://www2.openclinica.com/l/5352/2017-03-02/51xd41 && \

     unzip openclinica.zip && \
     unzip openclinica-ws.zip && \

#### Remove default webapps
     rm -rf $CATALINA_HOME/webapps/* && \

     mkdir $OC_HOME && cd $OC_HOME && \
     cp /tmp/oc/OpenClinica-$OC_VERSION/distribution/OpenClinica.war . && \
     unzip OpenClinica.war && cd .. && \
    
     mkdir $OC_WS_HOME && cd $OC_WS_HOME && \
     cp /tmp/oc/OpenClinica-ws-$OC_VERSION/distribution/OpenClinica-ws.war . && \
     unzip OpenClinica-ws.war && cd .. && \
    
     rm -rf /tmp/oc && \

     mkdir $CATALINA_HOME/openclinica.data/xslt -p && \
     mv $CATALINA_HOME/webapps/OpenClinica/WEB-INF/lib/servlet-api-2.3.jar ../ && \
     chmod +x /*.sh

ENV  JAVA_OPTS -Xmx1280m -XX:+UseParallelGC -XX:+CMSClassUnloadingEnabled

CMD  ["/run.sh"]
