# Dockerfile for OpenClinica 3.4.1
#
# * for testing purposes only
# * needs an additional postgres container
#
FROM tutum/tomcat:7.0
MAINTAINER Jens Piegsa (piegsa@gmail.com)

ENV OC_HOME $CATALINA_HOME/webapps/OpenClinica
ENV OC_WS_HOME $CATALINA_HOME/webapps/OpenClinica-ws
ENV OC_VERSION 3.4.1

RUN mkdir /tmp/oc
ADD http://www2.openclinica.com/l/5352/2014-12-22/xpy3t /tmp/oc/
ADD http://www2.openclinica.com/l/5352/2014-12-22/xpy15 /tmp/oc/
RUN mkdir $OC_HOME && cd $OC_HOME && \
    cp /tmp/oc/OpenClinica-$OC_VERSION/distribution/OpenClinica.war . && \
    jar xf OpenClinica.war && cd .. && \
    mkdir $OC_WS_HOME && cd $OC_WS_HOME && \
    cp /tmp/oc/OpenClinica-ws-$OC_VERSION/distribution/OpenClinica-ws.war . && \
    jar xf OpenClinica-ws.war && cd .. && \
    rm -rf /tmp/oc
COPY run.sh /run.sh
RUN mkdir $CATALINA_HOME/openclinica.data/xslt -p && \
    mv $CATALINA_HOME/webapps/OpenClinica/WEB-INF/lib/servlet-api-2.3.jar ../ && \
    chmod +x /*.sh
ENV JAVA_OPTS -Xmx1280m -XX:+UseParallelGC -XX:MaxPermSize=180m -XX:+CMSClassUnloadingEnabled

CMD ["/run.sh"]
