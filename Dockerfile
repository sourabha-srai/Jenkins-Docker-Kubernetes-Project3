FROM tomcat:8.0.20-jre8

RUN mkdir /usr/local/tomcat/webapps/myapp

COPY kubernetes/target/k8sDemo-1.0-ss.war /usr/local/tomcat/webapps/sr.war
