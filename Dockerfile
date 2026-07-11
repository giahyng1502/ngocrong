# Stage 1: Build the source code using Ant and Java 21
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
# Install Ant
RUN apk add --no-cache apache-ant
# Copy the entire project
COPY . .
# Compile the project and build the JAR (usually placed in dist/NgocRongOnline.jar)
RUN ant jar

# Stage 2: Run the compiled JAR
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the compiled jar from the builder stage
COPY --from=builder /app/dist/NgocRongOnline.jar /app/server.jar
# Copy configuration and data
COPY Config.properties /app/
COPY data/ /app/data/
COPY lib/ /app/lib/

# Start the Java server
CMD ["java", "-server", "-Dfile.encoding=UTF-8", "-cp", "lib/*:server.jar", "nro.models.server.ServerManager"]
