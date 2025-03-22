FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /workspace
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x gradlew
RUN ./gradlew build -x test

FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=build /workspace/build/libs/*.jar app.jar

RUN apk add --no-cache wget

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java","-jar","/app/app.jar"]
