# User Service

The **User Service** is a microservice built with [Ballerina](https://ballerina.io/) that manages user profiles and preferences.  
It exposes a REST API for CRUD operations on users, JWT-based authentication, and PostgreSQL persistence.  

---

## 📂 Project Structure

user-service/ <br>
├── Ballerina.toml # Ballerina project config <br>
├── cloud.toml # Cloud build config <br>
├── Config.toml # Service configuration (DB & certs) <br>
├── Dependencies.toml # Auto-managed dependencies <br>
├── docker-compose.yml # Multi-container setup (Postgres + Service) <br>
├── Dockerfile # Service Docker build <br>
├── main.bal  <br>
├── service.bal # HTTP service & resources <br>
├── types.bal # Shared type definitions <br>
├── util.bal # JWT claims extraction utility <br>
├── public.crt # Public key for JWT validation <br>
├── .devcontainer.json # Devcontainer config for VS Code <br>
├── db/ <br>
│ └── init.sql # Database schema initialization<br>
└── logs/ # Logs directory<br>

    
---

## ⚙️ Configuration

All configurations are in `Config.toml`:

```toml
db_host = "user_service_db"
db_port = 5432
db_user = "user_service_user"
db_pass = "qwertyui"
db_name = "user_service_db"
pub_key = "public.crt"
```

--- 
## 🐳 Running with Docker Compose

### build docker image 

```
bal build --cloud=docker
```

### start the services
```
docker-compose up --build
```
### Stop containers
```
docker-compose down 
```
---
## 🚀 API Endpoints

Base URL:``` http://localhost:5000/user-service```


### 🔓 Public Endpoints <br>

| Method | Endpoint | Description |
|--------|---------|-------------|
| GET    | `/users` | Fetch all users |
| POST   | `/create-user` | Create a new user |
| PUT    | `/update-user/{id}` | Update a user by ID |
| DELETE | `/delete-user/{id}` | Delete a user |


### 🔒 Protected Endpoints (JWT Required)

All secured endpoints require an Authorization: Bearer <token> header.
JWT must have:
```
issuer: "Orbyte"

audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa"

Public cert: public.crt
```
| Method | Endpoint | Description |
|--------|---------|-------------|
| GET    | `/my` | Get current user profile |
| GET    | `/compatibility` | Get user compatibility |
---

## 📜 Example Requests

### Create User
```
curl -X POST http://localhost:5000/user-service/create-user \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Alice Doe",
    "email": "alice@example.com",
    "phoneNumber": "1234567890",
    "userAddress": "Colombo",
    "profilePicture": null
  }'
```
### Get Users
```curl http://localhost:5000/user-service/users```

### Get Authenticated User
```
curl -H "Authorization: Bearer <jwt_token>" \
  http://localhost:5000/user-service/my
```
---

## 🔑 Authentication & JWT

- JWTs are validated against `public.crt`
- Claims extracted in `util.bal`
- Required scopes: `user`

---

### ✨ Features


- CRUD for `users_profile`
- JWT authentication
- PostgreSQL persistence
- Dockerized & cloud-ready
- Configurable via `Config.toml`


---

