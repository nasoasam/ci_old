FROM maven:3.5.4-jdk-8

ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

EXPOSE 8080
CMD ["mvn spring-boot:run"]
