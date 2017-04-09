# Dockerfile for OpenClinica
#
# - for testing purposes only
# - needs an additional postgres container

#FROM tutum/tomcat:7.0
FROM tomcat:8.5.13-jre8

MAINTAINER Jens Piegsa (piegsa@gmail.com)

ENV OC_HOME    $CATALINA_HOME/webapps/OpenClinica
ENV OC_WS_HOME $CATALINA_HOME/webapps/OpenClinica-ws

ENV OC_VERSION 3.13

RUN ["mkdir", "/tmp/oc"]
RUN ["wget", "-q", "--no-check-certificate", "-O/tmp/oc/openclinica.zip", "http://www2.openclinica.com/l/5352/2017-03-02/51xd3y"]
RUN ["wget", "-q", "--no-check-certificate", "-O/tmp/oc/openclinica-ws.zip", "http://www2.openclinica.com/l/5352/2017-03-02/51xd41"]

RUN cd /tmp/oc && \
    jar xf openclinica.zip && \
    jar xf openclinica-ws.zip && \

	# remove default webapps
    rm -rf $CATALINA_HOME/webapps/* && \

    mkdir $OC_HOME && cd $OC_HOME && \
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
