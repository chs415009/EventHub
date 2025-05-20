FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/EventHub-0.0.1-SNAPSHOT.war app.war

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.war"]