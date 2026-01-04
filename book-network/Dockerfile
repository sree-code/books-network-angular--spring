# Use Amazon Corretto (OpenJDK) 17 as base image
FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src src

# Build the application
RUN ./mvnw clean package -DskipTests

# Expose port (Render will use $PORT environment variable)
EXPOSE 8088

# Run the application using shell form to allow environment variable substitution
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8088} -Dspring.profiles.active=prod -Xmx400m -Xms400m -jar target/book-network-0.0.1-SNAPSHOT.jar"]

