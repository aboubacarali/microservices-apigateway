# ----- STAGE 1: Build -----
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Utilise le cache Docker au max
COPY pom.xml .
RUN mvn dependency:go-offline

# Copie du code source
COPY src ./src

# Build sans exécuter les tests
RUN mvn package -DskipTests


# ----- STAGE 2: Runtime -----
FROM eclipse-temurin:21-jre-focal

WORKDIR /app

# Copie du jar depuis l’étape de build
COPY --from=build /app/target/*.jar app.jar

# Expose le port du microservice
EXPOSE 8080

# Démarrage de l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
