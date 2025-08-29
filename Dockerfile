FROM ballerina/ballerina:2201.12.7 AS builder

WORKDIR /app

COPY Ballerina.toml .
COPY *.bal .
# COPY persist/ persist/
# COPY modules/ modules/

RUN bal build

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/bin/user_service.jar .

RUN mkdir -p logs

EXPOSE 5000

CMD ["java", "-jar", "user_service.jar"]
