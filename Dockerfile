# DO NOT USE - WORK IN PROGRESS!

FROM centos:centos6

MAINTAINER Jens Piegsa  <piegsa@gmail.com>

# install tools
RUN yum -y update  
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install nano
RUN yum -y install unzip

# install java 7
RUN yum -y install java-1.7.0-openjdk  

# install tomcat 7
ENV TOMCAT_VERSION 7.0.55
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz
RUN rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs 

# set environment variables
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# execute
EXPOSE 8080
CMD $CATALINA_HOME/bin/catalina.sh run
