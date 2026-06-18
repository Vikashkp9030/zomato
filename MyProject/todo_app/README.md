# TODO App - Gin Framework

A simple and robust TODO application built with Go Gin framework and GORM with SQLite database.

## Project Structure

```
todo_app/
├── main.go              # Entry point
├── go.mod               # Module dependencies
├── models/              # Data models
│   └── todo.go         # Todo model and request structs
├── handlers/            # HTTP handlers
│   └── todo_handler.go # CRUD operations for todos
├── routes/              # API routes setup
│   └── routes.go       # Route definitions
├── database/            # Database configuration
│   └── db.go           # Database initialization and migration
├── config/              # Configuration
│   └── config.go       # App configuration from env variables
├── middleware/          # Custom middleware
│   └── cors.go         # CORS middleware
└── README.md           # This file
```

## Setup

### Prerequisites
- Go 1.21 or higher
- SQLite (included with most systems)

### Installation

1. Navigate to the project directory:
```bash
cd todo_app
```

2. Download dependencies:
```bash
go mod download
go mod tidy
```

3. Run the application:
```bash
go run main.go
```

The server will start on `http://localhost:8080`

## Configuration

You can configure the application using environment variables:

```bash
PORT=8080           # Server port (default: 8080)
DB_PATH=todos.db    # Database file path (default: todos.db)
GIN_MODE=debug      # Gin mode: debug, release (default: debug)
```

Example:
```bash
PORT=3000 DB_PATH=mydb.db GIN_MODE=release go run main.go
```

## API Endpoints

### Base URL
```
http://localhost:8080/api/todos
```

### 1. Create a Todo
- **Endpoint:** `POST /api/todos`
- **Request Body:**
```json
{
  "title": "Buy groceries"
}
```
- **Response:** `201 Created`
```json
{
  "id": 1,
  "title": "Buy groceries",
  "completed": false,
  "created_at": 1718000000,
  "updated_at": 1718000000
}
```

### 2. Get All Todos
- **Endpoint:** `GET /api/todos`
- **Response:** `200 OK`
```json
[
  {
    "id": 1,
    "title": "Buy groceries",
    "completed": false,
    "created_at": 1718000000,
    "updated_at": 1718000000
  },
  {
    "id": 2,
    "title": "Complete project",
    "completed": true,
    "created_at": 1718000000,
    "updated_at": 1718000000
  }
]
```

### 3. Get Todo by ID
- **Endpoint:** `GET /api/todos/:id`
- **Response:** `200 OK`
```json
{
  "id": 1,
  "title": "Buy groceries",
  "completed": false,
  "created_at": 1718000000,
  "updated_at": 1718000000
}
```

### 4. Update Todo
- **Endpoint:** `PUT /api/todos/:id`
- **Request Body:**
```json
{
  "title": "Buy groceries and supplies",
  "completed": true
}
```
- **Response:** `200 OK`
```json
{
  "id": 1,
  "title": "Buy groceries and supplies",
  "completed": true,
  "created_at": 1718000000,
  "updated_at": 1718000100
}
```

### 5. Delete Todo
- **Endpoint:** `DELETE /api/todos/:id`
- **Response:** `200 OK`
```json
{
  "message": "Todo deleted successfully"
}
```

### 6. Delete All Todos
- **Endpoint:** `DELETE /api/todos`
- **Response:** `200 OK`
```json
{
  "message": "All todos deleted successfully"
}
```

### 7. Health Check
- **Endpoint:** `GET /health`
- **Response:** `200 OK`
```json
{
  "message": "API is running"
}
```

## Testing with cURL

### Create a todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Buy groceries"}'
```

### Get all todos
```bash
curl http://localhost:8080/api/todos
```

### Get a specific todo
```bash
curl http://localhost:8080/api/todos/1
```

### Update a todo
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Buy groceries and milk","completed":true}'
```

### Delete a todo
```bash
curl -X DELETE http://localhost:8080/api/todos/1
```

### Delete all todos
```bash
curl -X DELETE http://localhost:8080/api/todos
```

## Database

The application uses SQLite for data persistence. The database file (`todos.db` by default) is created automatically on first run.

### Database Schema

```sql
CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  completed BOOLEAN DEFAULT false,
  created_at INTEGER,
  updated_at INTEGER,
  deleted_at INTEGER
);
```

## Error Handling

The API returns appropriate HTTP status codes:
- `200 OK` - Successful GET/PUT/DELETE
- `201 Created` - Successful POST
- `400 Bad Request` - Invalid request data
- `404 Not Found` - Todo not found
- `500 Internal Server Error` - Server error

## Features

- ✅ Full CRUD operations
- ✅ SQLite database with GORM ORM
- ✅ CORS enabled for frontend integration
- ✅ Structured project layout
- ✅ Configuration management
- ✅ Error handling
- ✅ Soft deletes support

## License

MIT
