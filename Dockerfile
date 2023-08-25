FROM adoptopenjdk/openjdk11:ubi
ARG artifact=appcode/target/spring-boot-web.jar
WORKDIR /opt/app
COPY ${artifact} app.jar
ENTRYPOINT ["java","-jar","app.jar"]