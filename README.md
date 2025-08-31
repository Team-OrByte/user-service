# User Service

[![CI](https://github.com/Team-OrByte/payment-service/actions/workflows/automation.yaml/badge.svg)](https://github.com/Team-OrByte/user-service/actions/workflows/automation.yaml)
[![Docker Image](https://img.shields.io/badge/docker-thetharz%2Forbyte__user__service-blue)](https://hub.docker.com/r/thetharz/orbyte_user_service)

A Ballerina-based user management microservice that integrates with PostgreSQL for persistence and JWT for access control. This service handles user CRUD operations, authenticated “my profile” retrieval, and compatibility flag checks within the OrByte ride-hailing application ecosystem. 

---
## How Ballerina is Used
This project leverages Ballerina's cloud-native capabilities and built-in connectors for:

- Service Orchestration: Ballerina HTTP services manage user CRUD, profile and compatibility endpoints
- Database Integration: PostgreSQL connector for persistent user data storage
- Configuration Management: External configuration support for environment-specific settings
- Security: JWT validation with certificate-based signature verification
- Observability & Logging: Structured logs for request/DB operations (file-based log output)

### Key Ballerina Features Used

- Configurable variables for environment-specific settings
- Built-in connectors for PostgreSQL and HTTP
- JSON data binding and type safety with records
- Error handling and logging
- JWT auth with issuer/audience/scope validation
---

## Configuration Example
Create a ```Config.toml``` file with the following structure:

```
# PostgreSQL Configuration
db_host = "user_service_db"
db_port = 5432
db_user = "user_service_user"
db_pass = "qwertyui"
db_name = "user_service_db"

# JWT Public Key Certificate (mounted path inside container/host)
pub_key = "public.crt"
```
---
## API Endpoints
#### REST Endpoints (Port 5000)

Base path: ```/user-service```

#### Get All Users

**Path**: `/users`  <br>
**Method**:` GET` <br>
**Description**: Returns a list of users.
 #### Success Response Example:

 ```
{
  "message": "users list retrieved successfully",
  "data": [
    {
      "userId": "a1b2c3",
      "fullName": "Jane Doe",
      "email": "jane@example.com",
      "phoneNumber": "+9471XXXXXXX",
      "userAddress": "Colombo",
      "profilePicture": "https://.../pic.jpg",
      "createdAt": "2025-08-12T12:22:28Z",
      "updatedAt": "2025-08-12T12:22:28Z",
      "compatibility": true
    }
  ]
}
```
#### Create User

**Path**: `/create-user`<br>
**Method**: `POST` <br>
**Description**: Creates a new user if email/phone are unique. <br>
**Request Body**:
```
{
  "fullName": "Jane Doe",
  "email": "jane@example.com",
  "phoneNumber": "+9471XXXXXXX",
  "userAddress": "Colombo",
  "profilePicture": "https://.../pic.jpg"
}

```
#### Success Response 
```
{ "message": "User created successfully", "data": { "id": "generated-uuid" } }

```
#### Duplicate Response
```
{ "message": "User already exists", "data": [] }

```
#### Update User

**Path**: `/update-user/{userId}`<br>
**Method**:`PUT`<br>
**Description**:  updates an existing user.<br>

**Request Body** :
```
{
  "fullName": "Jane A. Doe",
  "email": "jane@example.com",
  "phoneNumber": "+9471XXXXXXX",
  "userAddress": "Kandy",
  "profilePicture": "https://.../newpic.jpg"
}

```

#### Success Response:
```
{ "message": "User updated successfully", "data": { "id": "userId" } }
```

### JWT-Protected Endpoints

**JWT is validated with**:
```
Issuer: Orbyte

Audience: vEwzbcasJVQm1jVYHUHCjhxZ4tYa

Scope Key: scp

Required Scope: user

Signature: X.509 certificate file path from pub_key
```
**Include header**: 
`Authorization: Bearer <JWT>` <br>
use the token issued from the auth-service 

#### Get My Profile

**Path**: `/my`<br>
**Method**: `GET` <br>
**Auth**: `JWT (scp=user)`<br>
**Description**: Returns the authenticated user’s profile inferred from JWT userId.

#### Success Response:
```
{
  "message": "user retrieved successfully",
  "data": {
    "userId": "jwt-user-id",
    "fullName": "Jane Doe",
    "email": "jane@example.com",
    "phoneNumber": "+9471XXXXXXX",
    "userAddress": "Colombo",
    "profilePicture": "https://.../pic.jpg",
    "createdAt": "2025-08-12T12:22:28Z",
    "updatedAt": "2025-08-12T12:22:28Z",
    "compatibility": true
  }
}
```
---
## User Service Flow

1. User Creation: Client creates a user record (public endpoint)

2. Authentication: Client authenticates elsewhere to obtain a JWT issued for the OrByte ecosystem

3. Profile Access: Client calls /my with Authorization: Bearer <JWT> to fetch their profile

4. Profile Maintenance: Client updates or deletes user data via respective endpoints

5. Compatibility Check: Client calls /compatibility (JWT required) to retrieve compatibility status

--- 

License

This project is part of the OrByte team's ride-hailing application ecosystem.

