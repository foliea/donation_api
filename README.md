# Donation API

## 📌 Overview
This is a RESTful API that allows users to **record donations** to projects and **retrieve their total donations** converted to a specified currency.

### **Features**
- Token-based authentication using `api_token`.
- Users can **record** donations with an amount, currency, and project identifier.
- Users can **retrieve** their total donations, converted into a specified currency.
- Uses **PostgreSQL** as the database.
- Runs inside **Docker** for easy setup and testing.

---
## 🚀 **Getting Started**

### **1. Clone the Repository**
Then:
```sh
cd donation_api
```

### **2. Setup with Docker**
Ensure you have **Docker** installed, then run:
```sh
docker-compose up --build
```
This will:
- Set up **PostgreSQL** databases (development & test).
- Run the **Rails server** at `http://localhost:3000`.

### **3. Setup Database**
Run the following inside the `api` container:
```sh
docker-compose exec api rails db:create db:migrate db:seed
```

### **4. Running Tests**
Run the test suite inside the `test` container:
```sh
docker-compose run --rm test
```

---
## 📌 **API Endpoints**

### 📌 **Authentication**
- Every **User** has an `api_token` stored in the database.
- Requests **must** include an `Authorization` header with the token.
- Users can only access **their own** donation data.
- To create a new user with an API token, run:
  ```sh
  docker-compose exec api rake user:create
  ```
  This will generate and display a new user ID and API token.

### **1️⃣ Record a Donation**
#### **POST** `/api/donations`
Records a user's donation to a project.

#### **Request Headers**
```json
{
  "Authorization": "<API_TOKEN>"
}
```

#### **Request Body**
```json
{
  "amount": 100,
  "currency": "USD",
  "project_id": 1
}
```

#### **Response (201 Created)**
```json
{
  "donation": {
    "id": 1,
    "amount": 100,
    "currency": "USD",
    "project_id": 1
  }
}
```

### **2️⃣ Get Total Donations**
#### **GET** `/api/donations/total?currency=EUR`
Returns the total donation amount converted to the specified currency.

#### **Request Headers**
```json
{
  "Authorization": "<API_TOKEN>"
}
```

#### **Response (200 OK)**
```json
{
  "total_amount": 150,
  "currency": "EUR"
}
```

---
## 📌 **License**
MIT License
