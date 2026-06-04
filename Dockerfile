FROM eclipse-temurin:11-jre-slim

RUN useradd -m myappuser
USER myappuser

WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
