# Booking App Backend

## Scripts

**Dev**

- `./mvnw spring-boot:run`
- `./mvnw clean package`

Open localhost:8080

**Build**

- `docker build . -t sg6/booking-app-backend -f ./docker/Dockerfile`
- `docker run -p 8081:8080 sg6/booking-app-backend`

Open localhost:8081