# Dockerfile for OpenCLinica
#
# - for testing purposes only
# - needs an additional postgres container
#
FROM tutum/tomcat:7.0
MAINTAINER Jens Piegsa <piegsa@gmail.com>

ENV OC_VERSION 3.3
ENV JAVA_OPTS -Xmx1280m -XX:+UseParallelGC -XX:MaxPermSize=180m -XX:+CMSClassUnloadingEnabled

ADD run.sh /run.sh

RUN apt-get update && apt-get install unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /tmp/oc && \
    wget -q http://www2.openclinica.com/l/5352/2014-07-25/x24m7 -O /tmp/oc/openclinica.zip && \
    wget -q https://community.openclinica.com/sites/fileuploads/akaza/cms-community/OpenClinica-ws-3.3.zip -O /tmp/oc/openclinica-ws.zip && \
    unzip -oq /tmp/oc/openclinica -d /tmp/oc && \
    unzip -oq /tmp/oc/openclinica-ws -d /tmp/oc && \
    cd /tmp/oc/OpenClinica-${OC_VERSION}/distribution && \
    unzip -oq OpenClinica.war -d OpenClinica && \
    cp -rf OpenClinica* ${CATALINA_HOME}/webapps && \
    cd /tmp/oc/OpenClinica-ws-${OC_VERSION}/distribution && \
    unzip -oq OpenClinica-ws.war -d OpenClinica-ws && \
    cp -rf OpenClinica* ${CATALINA_HOME}/webapps && \
    mkdir ${CATALINA_HOME}/openclinica.data/xslt -p && \
    mv ${CATALINA_HOME}/webapps/OpenClinica/WEB-INF/lib/servlet-api-2.3.jar ../ && \
    chmod +x /*.sh
#RUN rm -rf /tmp/oc

CMD ["/run.sh"]
