# Default images use DaoCloud mirror (better for CN networks).
# Override in docker-compose build.args or: docker build --build-arg MAVEN_IMAGE=...
ARG MAVEN_IMAGE=docker.m.daocloud.io/library/maven:3.8.6-eclipse-temurin-8
ARG JRE_IMAGE=docker.m.daocloud.io/library/eclipse-temurin:8-jre-jammy

# Build stage
FROM ${MAVEN_IMAGE} AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -DskipTests package

# Run stage
FROM ${JRE_IMAGE}
WORKDIR /app
RUN mkdir -p /app/uploads
COPY --from=build /app/target/hm-dianping-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8081
ENV SPRING_PROFILES_ACTIVE=docker
ENV IMAGE_UPLOAD_DIR=/app/uploads
ENTRYPOINT ["java", "-jar", "app.jar"]
