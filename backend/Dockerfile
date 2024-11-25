# Build the application
FROM maven:3.8-openjdk-17 AS build
WORKDIR /backend-app
COPY pom.xml .
COPY src ./src
RUN mvn clean install -DskipTests

# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /backend-app

# Copy the JAR file into the container
COPY --from=build /backend-app/target/tic-tac-toe-0.0.1-SNAPSHOT.jar /backend-app/app.jar

# Expose the port your application runs on
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/backend-app/app.jar"]
