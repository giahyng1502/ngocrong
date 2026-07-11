FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the compiled jar and dependencies
COPY dist/NgocRongOnline.jar /app/server.jar
COPY Config.properties /app/
COPY data/ /app/data/
COPY lib/ /app/lib/

# Start the Java server
CMD ["java", "-server", "-Dfile.encoding=UTF-8", "-cp", "lib/*:server.jar", "nro.models.server.ServerManager"]
