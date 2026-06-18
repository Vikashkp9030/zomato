# Complete TODO API Reference

## Overview

A comprehensive REST API for managing todos with advanced features including categories, tags, users, priorities, and due dates. Built with Go, Gin, GORM, and SQLite.

## Base URL

```
http://localhost:8080/api
```

---

## TODO Endpoints

### 1. Create Todo
**Endpoint:** `POST /api/todos`

**Request Body:**
```json
{
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "priority": "high",
  "status": "todo",
  "due_date": "2024-06-30T10:00:00Z",
  "category_id": 1,
  "tag_ids": [1, 2],
  "user_id": 1
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "completed": false,
  "priority": "high",
  "status": "todo",
  "due_date": "2024-06-30T10:00:00Z",
  "category_id": 1,
  "category": {
    "id": 1,
    "name": "Shopping",
    "color": "#3B82F6"
  },
  "tags": [
    {"id": 1, "name": "urgent"},
    {"id": 2, "name": "food"}
  ],
  "user_id": 1,
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com"
  },
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 2. Get All Todos (with Filtering & Pagination)
**Endpoint:** `GET /api/todos`

**Query Parameters:**
- `status` - Filter by status (todo, in_progress, done, archived)
- `priority` - Filter by priority (low, medium, high)
- `completed` - Filter by completion (true/false)
- `category_id` - Filter by category ID
- `user_id` - Filter by user ID
- `tag_id` - Filter by tag ID
- `search` - Search in title and description
- `sort_by` - Sort field (created_at, due_date, priority) - default: created_at
- `order` - Sort order (asc, desc) - default: desc
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 10)

**Example:**
```bash
GET /api/todos?status=todo&priority=high&page=1&limit=5
```

**Response:** `200 OK`
```json
{
  "data": [
    {
      "id": 1,
      "title": "Buy groceries",
      "description": "Milk, eggs, bread",
      "completed": false,
      "priority": "high",
      "status": "todo",
      "due_date": "2024-06-30T10:00:00Z",
      "category_id": 1,
      "category": {...},
      "tags": [...],
      "user_id": 1,
      "created_at": 1719750000,
      "updated_at": 1719750000
    }
  ],
  "total": 15,
  "page": 1,
  "limit": 5,
  "total_pages": 3
}
```

### 3. Get Todo by ID
**Endpoint:** `GET /api/todos/:id`

**Response:** `200 OK`
```json
{
  "id": 1,
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "completed": false,
  "priority": "high",
  "status": "todo",
  "due_date": "2024-06-30T10:00:00Z",
  "category_id": 1,
  "category": {...},
  "tags": [...],
  "user_id": 1,
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 4. Update Todo
**Endpoint:** `PUT /api/todos/:id`

**Request Body:**
```json
{
  "title": "Buy groceries and milk",
  "description": "Updated description",
  "completed": true,
  "priority": "medium",
  "status": "in_progress",
  "due_date": "2024-07-01T10:00:00Z",
  "category_id": 2,
  "tag_ids": [1, 3],
  "user_id": 2
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "title": "Buy groceries and milk",
  "description": "Updated description",
  "completed": true,
  "priority": "medium",
  "status": "in_progress",
  "due_date": "2024-07-01T10:00:00Z",
  "category_id": 2,
  "category": {...},
  "tags": [...],
  "user_id": 2,
  "created_at": 1719750000,
  "updated_at": 1719750100
}
```

### 5. Delete Todo
**Endpoint:** `DELETE /api/todos/:id`

**Response:** `200 OK`
```json
{
  "message": "Todo deleted successfully"
}
```

### 6. Delete All Todos
**Endpoint:** `DELETE /api/todos`

**Response:** `200 OK`
```json
{
  "message": "All todos deleted successfully"
}
```

### 7. Search Todos
**Endpoint:** `GET /api/todos/search?q=keyword`

**Query Parameters:**
- `q` - Search keyword (required)

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "completed": false,
    "priority": "high",
    "status": "todo",
    "created_at": 1719750000,
    "updated_at": 1719750000
  }
]
```

### 8. Get Todo Stats
**Endpoint:** `GET /api/todos/stats`

**Response:** `200 OK`
```json
{
  "total_todos": 25,
  "completed_todos": 10,
  "pending_todos": 15,
  "high_priority": 5,
  "overdue_todos": 2,
  "todos_by_category": {
    "Shopping": 8,
    "Work": 12,
    "Personal": 5
  },
  "todos_by_status": {
    "todo": 10,
    "in_progress": 5,
    "done": 10,
    "archived": 0
  }
}
```

### 9. Get Todos by Due Date
**Endpoint:** `GET /api/todos/due/:date`

**Path Parameters:**
- `date` - Date in format YYYY-MM-DD

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "due_date": "2024-06-30T10:00:00Z",
    "priority": "high",
    "status": "todo"
  }
]
```

### 10. Get Upcoming Todos
**Endpoint:** `GET /api/todos/upcoming?days=7`

**Query Parameters:**
- `days` - Number of days ahead (default: 7)

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "due_date": "2024-06-30T10:00:00Z",
    "priority": "high",
    "status": "todo"
  }
]
```

### 11. Bulk Update Todos
**Endpoint:** `POST /api/todos/bulk-update`

**Request Body:**
```json
{
  "ids": [1, 2, 3],
  "status": "done",
  "completed": true,
  "priority": "high"
}
```

**Response:** `200 OK`
```json
{
  "message": "Todos updated successfully"
}
```

### 12. Bulk Delete Todos
**Endpoint:** `POST /api/todos/bulk-delete`

**Request Body:**
```json
{
  "ids": [1, 2, 3]
}
```

**Response:** `200 OK`
```json
{
  "message": "Todos deleted successfully"
}
```

---

## Category Endpoints

### 1. Create Category
**Endpoint:** `POST /api/categories`

**Request Body:**
```json
{
  "name": "Shopping",
  "description": "Shopping related tasks",
  "color": "#3B82F6"
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "name": "Shopping",
  "description": "Shopping related tasks",
  "color": "#3B82F6",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 2. Get All Categories
**Endpoint:** `GET /api/categories`

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "name": "Shopping",
    "description": "Shopping related tasks",
    "color": "#3B82F6",
    "created_at": 1719750000,
    "updated_at": 1719750000
  }
]
```

### 3. Get Category by ID
**Endpoint:** `GET /api/categories/:id`

**Response:** `200 OK`
```json
{
  "id": 1,
  "name": "Shopping",
  "description": "Shopping related tasks",
  "color": "#3B82F6",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 4. Get Category Todos
**Endpoint:** `GET /api/categories/:id/todos`

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "category_id": 1,
    "priority": "high",
    "status": "todo"
  }
]
```

### 5. Update Category
**Endpoint:** `PUT /api/categories/:id`

**Request Body:**
```json
{
  "name": "Shopping Updated",
  "description": "Updated description",
  "color": "#EF4444"
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "name": "Shopping Updated",
  "description": "Updated description",
  "color": "#EF4444",
  "created_at": 1719750000,
  "updated_at": 1719750100
}
```

### 6. Delete Category
**Endpoint:** `DELETE /api/categories/:id`

**Response:** `200 OK`
```json
{
  "message": "Category deleted successfully"
}
```

---

## Tag Endpoints

### 1. Create Tag
**Endpoint:** `POST /api/tags`

**Request Body:**
```json
{
  "name": "urgent"
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "name": "urgent",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 2. Get All Tags
**Endpoint:** `GET /api/tags`

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "name": "urgent",
    "created_at": 1719750000,
    "updated_at": 1719750000
  }
]
```

### 3. Get Tag by ID
**Endpoint:** `GET /api/tags/:id`

**Response:** `200 OK`
```json
{
  "id": 1,
  "name": "urgent",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 4. Get Tag Todos
**Endpoint:** `GET /api/tags/:id/todos`

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "tag_ids": [1, 2],
    "priority": "high"
  }
]
```

### 5. Update Tag
**Endpoint:** `PUT /api/tags/:id`

**Request Body:**
```json
{
  "name": "urgent-high"
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "name": "urgent-high",
  "created_at": 1719750000,
  "updated_at": 1719750100
}
```

### 6. Delete Tag
**Endpoint:** `DELETE /api/tags/:id`

**Response:** `200 OK`
```json
{
  "message": "Tag deleted successfully"
}
```

---

## User Endpoints

### 1. Create User
**Endpoint:** `POST /api/users`

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "secure_password"
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 2. Get All Users
**Endpoint:** `GET /api/users`

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "created_at": 1719750000,
    "updated_at": 1719750000
  }
]
```

### 3. Get User by ID
**Endpoint:** `GET /api/users/:id`

**Response:** `200 OK`
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### 4. Get User Todos
**Endpoint:** `GET /api/users/:id/todos`

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "user_id": 1,
    "priority": "high",
    "status": "todo"
  }
]
```

### 5. Update User
**Endpoint:** `PUT /api/users/:id`

**Request Body:**
```json
{
  "username": "john_doe_updated",
  "email": "newemail@example.com",
  "password": "new_secure_password"
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "username": "john_doe_updated",
  "email": "newemail@example.com",
  "created_at": 1719750000,
  "updated_at": 1719750100
}
```

### 6. Delete User
**Endpoint:** `DELETE /api/users/:id`

**Response:** `200 OK`
```json
{
  "message": "User deleted successfully"
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "error": "Invalid request data"
}
```

### 404 Not Found
```json
{
  "error": "Todo not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Failed to create todo"
}
```

---

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Successful GET/PUT/DELETE |
| 201 | Created - Successful POST |
| 400 | Bad Request - Invalid input |
| 404 | Not Found - Resource not found |
| 500 | Server Error - Internal error |

---

## Data Types

### Priority
- `low` - Low priority
- `medium` - Medium priority (default)
- `high` - High priority

### Status
- `todo` - To do (default)
- `in_progress` - In progress
- `done` - Done
- `archived` - Archived

---

## Example Usage with cURL

### Create a Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "priority": "high",
    "status": "todo"
  }'
```

### Get All Todos with Filters
```bash
curl "http://localhost:8080/api/todos?status=todo&priority=high&page=1&limit=10"
```

### Search Todos
```bash
curl "http://localhost:8080/api/todos/search?q=groceries"
```

### Get Todo Stats
```bash
curl http://localhost:8080/api/todos/stats
```

### Create a Category
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Shopping",
    "color": "#3B82F6"
  }'
```

### Create a User
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "secure_password"
  }'
```

### Bulk Update Todos
```bash
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2, 3],
    "status": "done",
    "completed": true
  }'
```

---

## Summary

This TODO API provides:
- ✅ Full CRUD operations for todos, categories, tags, and users
- ✅ Advanced filtering and search capabilities
- ✅ Pagination and sorting
- ✅ Bulk operations
- ✅ Statistics and analytics
- ✅ Due date management
- ✅ Priority levels and status tracking
- ✅ Multi-user support
- ✅ Relationship management (categories, tags, users)

Total Endpoints: **40+**
