FROM maven:3.5.4-jdk-8

EXPOSE 8080
CMD ["mvn spring-boot:run"]
