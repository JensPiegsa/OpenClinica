# DO NOT USE -- WORK IN PROGRESS!
FROM centos:centos6
MAINTAINER Jens Piegsa  <piegsa@gmail.com>

# set versions
ENV TOMCAT_VERSION 7.0.55
ENV OC_VERSION 3.3

# install tools
RUN yum -y update  
RUN yum -y install wget tar unzip java-1.7.0-openjdk

# install tomcat
ENV CATALINA_HOME /usr/local/tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz
RUN tar xzf /tmp/tomcat.tar.gz -C ${CATALINA_HOME}/..
RUN ln -s ${CATALINA_HOME}/../apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME}
RUN rm /tmp/tomcat.tar.gz
RUN rm -rf ${CATALINA_HOME}/webapps/examples ${CATALINA_HOME}/webapps/docs 
ENV PATH $PATH:$CATALINA_HOME/bin

# install OpenClinica and OpenClinica-ws
RUN mkdir /tmp/oc
RUN wget -q http://www2.openclinica.com/l/5352/2014-07-25/x24m7 -O /tmp/oc/openclinica.zip
RUN wget -q https://community.openclinica.com/sites/fileuploads/akaza/cms-community/OpenClinica-ws-3.3.zip -O /tmp/oc/openclinica-ws.zip
RUN unzip -oq /tmp/oc/openclinica -d /tmp/oc
RUN unzip -oq /tmp/oc/openclinica-ws -d /tmp/oc
RUN cd /tmp/oc/OpenClinica-${OC_VERSION}/distribution
RUN unzip -oq OpenClinica.war -d OpenClinica
RUN cp -rf OpenClinica* ${CATALINA_HOME}/webapps
RUN cd /tmp/oc/OpenClinica-ws-${OC_VERSION}/distribution
RUN unzip -oq OpenClinica-ws.war -d OpenClinica-ws
RUN cp -rf OpenClinica* ${CATALINA_HOME}/webapps
#RUN rm -rf /tmp/oc

# run
EXPOSE 8080
CMD $CATALINA_HOME/bin/catalina.sh run
