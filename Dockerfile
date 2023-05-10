FROM --platform=linux/amd64 maven:3.9.1-ibmjava-8 as build

ARG JAR_VERSION

COPY myapp /app
WORKDIR /app
RUN mvn package
LABEL jar-version=${JAR_VERSION}}

FROM --platform=linux/amd64 anapsix/alpine-java:8_jdk
ARG JAR_VERSION
LABEL jar-version=${JAR_VERSION}

RUN adduser -D runner
COPY --from=build --chown=1000:1000 /app/target/myapp-${JAR_VERSION}.jar /home/runner/myapp.jar
USER runner

CMD java -cp /home/runner/myapp.jar com.myapp.App