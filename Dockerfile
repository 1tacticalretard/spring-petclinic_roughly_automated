FROM maven:latest
EXPOSE 8080
COPY . /app
WORKDIR /app
ENTRYPOINT ["mvn","spring-boot:run","-Dspring-boot.run.profiles=mysql", "-DskipTests=true"]

