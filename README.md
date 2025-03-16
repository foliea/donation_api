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

### **2. Create an Environment File**

Create a `.env` file with:
```sh
EXCHANGE_RATE_API_KEY=<YOUR_API_KEY>
```

To get an exchange rate API key, you can follow this [link](https://www.exchangerate-api.com/).

### **3. Setup with Docker**
Ensure you have **Docker** installed, then run:
```sh
docker-compose up --build
```
This will:
- Set up **PostgreSQL** databases (development & test).
- Run the **Rails server** at `http://localhost:3000`.

> **Note:** The `--build` flag is needed only the first time or when dependencies change.

### **4. Setup Database**
Once the Docker containers are running, run:
```sh
docker-compose exec api rails db:create db:migrate db:seed
```

### **5. Running Tests**
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

---

### 🏗️ Create a New Project
To create donations, a project identifier is necessary. A rake task can be used to create projects in the database:
```sh
docker-compose exec api rake project:create[<YOUR_PROJECT_NAME>]
```

---

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

---

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

#### **Response (400 Bad Request - Invalid Currency)**
```json
{
  "error": "Currency must be ISO 4217."
}
```

---

## 🌍 **Supported Currencies**
The API supports **161 commonly used world currencies** based on the ISO 4217 standard. Some examples:

| Currency Code | Currency Name       | Country            |
|--------------|--------------------|-------------------|
| USD          | United States Dollar | United States     |
| EUR          | Euro                | European Union    |
| GBP          | Pound Sterling      | United Kingdom    |
| JPY          | Japanese Yen        | Japan             |
| AUD          | Australian Dollar   | Australia         |

For the full list of supported currencies, check [ISO 4217](https://www.iso.org/iso-4217-currency-codes.html).

---

## 📌 **Brief Explanation of My Approach**

### **1. Design & Architecture**
I followed **RESTful principles**, ensuring a clean separation of concerns:
- **Controllers** handle API requests.
- **Models** manage data.
- **Services** (e.g., `CurrencyConverter`) handle business logic.

### **2. Authentication & Donation Handling**
- Implemented **token-based authentication** (`api_token`) for user-specific access.
- Users can **record donations** with an amount, currency, and project ID.

### **3. Currency Conversion & Total Calculation**
- The `CurrencyConverter` service fetches real-time exchange rates and converts donations efficiently.
- Optimized the process by only passing necessary data.

### **4. Scalability & Reliability**
- **Modular design** for easy extension.
- **Error handling** ensures graceful failures.
- **Dockerized** for seamless setup and testing.

## 📌 **License**
MIT License
