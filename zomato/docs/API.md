# Zomato Food Delivery Platform - API Documentation

## Base URL
```
http://localhost:8000/api/v1
```

## Authentication
All endpoints (except login/register/health) require JWT token in Authorization header:
```
Authorization: Bearer <token>
```

## Response Format
```json
{
  "data": {...},
  "error": null,
  "status": "success",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

---

## 🔐 Authentication APIs

### Register User
```
POST /users/register
Content-Type: application/json

{
  "email": "user@example.com",
  "phone": "9876543210",
  "first_name": "John",
  "last_name": "Doe",
  "password": "password123",
  "role": "customer"
}

Response: 201 Created
{
  "id": "uuid",
  "email": "user@example.com",
  "token": "jwt_token"
}
```

### Login
```
POST /users/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response: 200 OK
{
  "user": {...},
  "token": "jwt_token"
}
```

### Refresh Token
```
POST /users/refresh
Content-Type: application/json
Authorization: Bearer <token>

{
  "refresh_token": "refresh_token_value"
}

Response: 200 OK
{
  "token": "new_jwt_token"
}
```

---

## 👤 User Profile APIs

### Get Profile
```
GET /users/profile
Authorization: Bearer <token>

Response: 200 OK
{
  "id": "uuid",
  "email": "user@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "role": "customer"
}
```

### Update Profile
```
PUT /users/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "first_name": "Jane",
  "last_name": "Smith",
  "phone": "9876543210"
}

Response: 200 OK
```

### Change Password
```
POST /users/change-password
Authorization: Bearer <token>
Content-Type: application/json

{
  "old_password": "current_password",
  "new_password": "new_password123"
}

Response: 200 OK
```

---

## 📍 Address APIs

### Get All Addresses
```
GET /users/addresses
Authorization: Bearer <token>

Response: 200 OK
[
  {
    "id": "uuid",
    "type": "home",
    "address": "123 Main St",
    "city": "New York",
    "zip_code": "10001"
  }
]
```

### Add Address
```
POST /users/addresses
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "home",
  "address": "123 Main St",
  "city": "New York",
  "state": "NY",
  "zip_code": "10001",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "is_default": true
}

Response: 201 Created
```

### Update Address
```
PUT /users/addresses/:id
Authorization: Bearer <token>
Content-Type: application/json
```

### Delete Address
```
DELETE /users/addresses/:id
Authorization: Bearer <token>

Response: 204 No Content
```

---

## 🍽️ Restaurant APIs

### List All Restaurants
```
GET /restaurants?limit=20&offset=0

Response: 200 OK
[
  {
    "id": "uuid",
    "name": "Pizza Hut",
    "city": "New York",
    "average_rating": 4.5,
    "total_reviews": 250
  }
]
```

### Search Restaurants
```
GET /restaurants/search?q=pizza&city=new_york

Response: 200 OK
```

### Get Restaurant Details
```
GET /restaurants/:id

Response: 200 OK
{
  "id": "uuid",
  "name": "Pizza Hut",
  "description": "Italian pizzeria",
  "address": "123 Main St",
  "average_rating": 4.5,
  "total_reviews": 250
}
```

### Get Restaurant Menu
```
GET /restaurants/:id/menu

Response: 200 OK
{
  "categories": [...],
  "dishes": [
    {
      "id": "uuid",
      "name": "Margherita Pizza",
      "price": 250.00,
      "is_veg": true
    }
  ]
}
```

### Create Restaurant (Owner only)
```
POST /restaurants
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Restaurant",
  "description": "Description",
  "address": "123 Main St",
  "city": "New York",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "phone_number": "9876543210",
  "email": "restaurant@example.com",
  "cuisine_types": ["Italian", "Vegetarian"]
}

Response: 201 Created
```

### Get Restaurant Reviews
```
GET /restaurants/:id/reviews

Response: 200 OK
[
  {
    "id": "uuid",
    "user_id": "uuid",
    "rating": 4.5,
    "comment": "Great pizza!",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

---

## 🛒 Order APIs

### Create Order
```
POST /orders
Authorization: Bearer <token>
Content-Type: application/json

{
  "restaurant_id": "uuid",
  "delivery_address_id": "uuid",
  "items": [
    {
      "dish_id": "uuid",
      "quantity": 2,
      "price": 250.00
    }
  ],
  "payment_method": "card",
  "notes": "No onions please"
}

Response: 201 Created
{
  "id": "uuid",
  "status": "placed",
  "total_amount": 500.00,
  "estimated_time": 45
}
```

### Get Orders
```
GET /orders
Authorization: Bearer <token>

Response: 200 OK
[
  {
    "id": "uuid",
    "restaurant_id": "uuid",
    "status": "delivered",
    "total_amount": 500.00
  }
]
```

### Track Order
```
GET /orders/:id/track

Response: 200 OK
{
  "order_id": "uuid",
  "status": "on_way",
  "current_location": {
    "latitude": 40.7128,
    "longitude": -74.0060
  },
  "estimated_arrival": 15
}
```

### Update Order Status
```
PUT /orders/:id/status
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "confirmed"
}

Response: 200 OK
```

### Cancel Order
```
PUT /orders/:id/cancel
Authorization: Bearer <token>

Response: 200 OK
```

---

## 🛍️ Cart APIs

### Get Cart
```
GET /cart
Authorization: Bearer <token>

Response: 200 OK
{
  "id": "uuid",
  "items": [
    {
      "id": "uuid",
      "dish_id": "uuid",
      "quantity": 2,
      "price": 250.00
    }
  ]
}
```

### Add to Cart
```
POST /cart
Authorization: Bearer <token>
Content-Type: application/json

{
  "restaurant_id": "uuid",
  "dish_id": "uuid",
  "quantity": 2,
  "price": 250.00
}

Response: 201 Created
```

### Update Cart Item
```
PUT /cart/:itemId
Authorization: Bearer <token>
Content-Type: application/json

{
  "quantity": 3
}

Response: 200 OK
```

### Remove from Cart
```
DELETE /cart/:itemId
Authorization: Bearer <token>

Response: 204 No Content
```

---

## 💳 Payment APIs

### Initiate Payment
```
POST /payments/initiate
Authorization: Bearer <token>
Content-Type: application/json

{
  "order_id": "uuid",
  "amount": 500.00,
  "method": "card"
}

Response: 201 Created
{
  "id": "uuid",
  "status": "pending",
  "amount": 500.00
}
```

### Confirm Payment
```
POST /payments/confirm
Authorization: Bearer <token>
Content-Type: application/json

{
  "payment_id": "uuid"
}

Response: 200 OK
```

### Get Wallet Balance
```
GET /wallet/balance
Authorization: Bearer <token>

Response: 200 OK
{
  "balance": 1000.00
}
```

### Add to Wallet
```
POST /wallet/add
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 500.00
}

Response: 200 OK
```

---

## 🚚 Delivery APIs

### Assign Delivery
```
POST /deliveries/assign
Authorization: Bearer <token>
Content-Type: application/json

{
  "order_id": "uuid",
  "pickup_address": "Restaurant address",
  "delivery_address": "Customer address"
}

Response: 201 Created
```

### Update Delivery Location
```
PUT /deliveries/partner/location
Authorization: Bearer <token>
Content-Type: application/json

{
  "order_id": "uuid",
  "latitude": 40.7128,
  "longitude": -74.0060
}

Response: 200 OK
```

### Get Partner Earnings
```
GET /deliveries/partner/earnings
Authorization: Bearer <token>

Response: 200 OK
{
  "total_earnings": 5000.00,
  "total_deliveries": 50
}
```

### Complete Order
```
PUT /deliveries/partner/complete/:orderId
Authorization: Bearer <token>

Response: 200 OK
```

---

## ⭐ Review APIs

### Get Restaurant Reviews
```
GET /reviews/restaurant/:restId

Response: 200 OK
[
  {
    "id": "uuid",
    "rating": 4.5,
    "comment": "Great food!",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### Create Review
```
POST /reviews
Authorization: Bearer <token>
Content-Type: application/json

{
  "restaurant_id": "uuid",
  "order_id": "uuid",
  "rating": 4.5,
  "title": "Excellent!",
  "comment": "Great food and service"
}

Response: 201 Created
```

### Like Review
```
POST /reviews/:id/like
Authorization: Bearer <token>

Response: 200 OK
```

---

## 🔔 Notification APIs

### Get Notifications
```
GET /notifications
Authorization: Bearer <token>

Response: 200 OK
[
  {
    "id": "uuid",
    "message": "Your order is ready!",
    "read": false,
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### Mark as Read
```
PUT /notifications/:id/read
Authorization: Bearer <token>

Response: 200 OK
```

---

## 🛡️ Admin APIs

### Get All Users
```
GET /admin/users
Authorization: Bearer <admin_token>

Response: 200 OK
```

### Get Pending Restaurants
```
GET /admin/restaurants/pending
Authorization: Bearer <admin_token>

Response: 200 OK
```

### Approve Restaurant
```
PUT /admin/restaurants/:id/approve
Authorization: Bearer <admin_token>

Response: 200 OK
```

### Get Analytics
```
GET /admin/analytics/orders
Authorization: Bearer <admin_token>

Response: 200 OK
{
  "total_orders": 1000,
  "today_orders": 50,
  "revenue": 250000
}
```

---

## Error Codes

| Code | Status | Description |
|------|--------|-------------|
| 400 | Bad Request | Invalid input |
| 401 | Unauthorized | Missing/invalid token |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource already exists |
| 422 | Unprocessable Entity | Validation error |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |
| 503 | Service Unavailable | Service down |

---

## Rate Limiting
- 100 requests per minute for authenticated users
- 20 requests per minute for unauthenticated users

## Pagination
Default limit: 20
Maximum limit: 100

---

## WebSocket Events (Optional)
```
ws://localhost:8000/ws/orders/:orderId
ws://localhost:8000/ws/deliveries/:orderId
```

---

## Testing
Use Postman collection: `postman_collection.json`

Import and test all endpoints with sample data.
