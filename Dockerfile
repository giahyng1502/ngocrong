FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy necessary files
COPY 20.jar /app/
COPY Config.properties /app/
COPY data/ /app/data/
COPY lib/ /app/lib/

# Run the server
CMD ["java", "-server", "-Dfile.encoding=UTF-8", "-jar", "20.jar"]
