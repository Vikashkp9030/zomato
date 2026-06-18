# TODO API - Quick Start Guide

## 🚀 Getting Started (5 minutes)

### 1. Start the Server
```bash
cd /Users/vikashkumarpatel/GoCourse/MyProject/todo_app
go run main.go
```

You should see:
```
[GIN-debug] Loaded HTML Templates (0): 
[GIN-debug] Listening and serving HTTP on :8080
```

### 2. Test the API

#### Option A: Using cURL (Simple)
```bash
# Create a todo
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Go"}'

# Get all todos
curl http://localhost:8080/api/todos

# Get specific todo
curl http://localhost:8080/api/todos/1

# Update todo
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'

# Delete todo
curl -X DELETE http://localhost:8080/api/todos/1
```

#### Option B: Using Postman (GUI)
1. Open Postman
2. Click **Import**
3. Select `todo_api_collection.json` from the project
4. Set the `base_url` variable to `http://localhost:8080`
5. Click on any request and click **Send**

#### Option C: Using Insomnia (GUI)
1. Open Insomnia
2. Click **Create** → **Import from File**
3. Select `insomnia_collection.json` from the project
4. Set the `base_url` environment variable to `http://localhost:8080`
5. Click on any request and press `Ctrl+Enter`

#### Option D: Using the Test Script
```bash
chmod +x test_api.sh
./test_api.sh
```

---

## 📚 API Endpoints Summary

### Create Todo
```bash
POST /api/todos
Content-Type: application/json

{"title": "Buy groceries"}
```

### Get All Todos
```bash
GET /api/todos
```

### Get Todo by ID
```bash
GET /api/todos/1
```

### Update Todo
```bash
PUT /api/todos/1
Content-Type: application/json

{"title": "Updated title", "completed": true}
```

### Delete Todo
```bash
DELETE /api/todos/1
```

### Delete All Todos
```bash
DELETE /api/todos
```

---

## 📁 File Guide

| File | Purpose |
|------|---------|
| `main.go` | Application entry point |
| `models/todo.go` | Data models and request/response structs |
| `handlers/todo_handler.go` | API handlers for CRUD operations |
| `routes/routes.go` | Route definitions |
| `database/db.go` | Database initialization and migration |
| `config/config.go` | Configuration from environment variables |
| `middleware/cors.go` | CORS middleware |
| `todo_api_collection.json` | Postman collection |
| `insomnia_collection.json` | Insomnia collection |
| `CURL_COMMANDS.md` | cURL examples for all endpoints |
| `API_EXAMPLES.md` | Detailed examples and workflows |
| `test_api.sh` | Automated test script |

---

## 🛠️ Common Commands

### Build the Application
```bash
go build -o todo_app
```

### Run the Built Binary
```bash
./todo_app
```

### Install Dependencies
```bash
go mod tidy
```

### Run with Custom Port
```bash
PORT=3000 go run main.go
```

### Run in Release Mode
```bash
GIN_MODE=release go run main.go
```

---

## 💡 Example Workflows

### Workflow 1: Create and Complete a Todo
```bash
# Create
RESPONSE=$(curl -s -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Buy groceries"}')

ID=$(echo $RESPONSE | jq '.id')

# Mark as complete
curl -X PUT http://localhost:8080/api/todos/$ID \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'
```

### Workflow 2: List and Delete
```bash
# Get all
curl http://localhost:8080/api/todos | jq '.'

# Delete first one
curl -X DELETE http://localhost:8080/api/todos/1
```

---

## 🔍 Database Location

The SQLite database is created at: `todos.db`

To inspect it:
```bash
sqlite3 todos.db "SELECT * FROM todos;"
```

---

## ❓ Troubleshooting

### Port Already in Use
```bash
# Use a different port
PORT=3000 go run main.go

# Or kill the process on 8080
lsof -ti:8080 | xargs kill -9
```

### Database Locked
Delete the database file and restart:
```bash
rm todos.db
go run main.go
```

### Module Not Found Error
```bash
go mod download
go mod tidy
```

---

## 📖 Full Documentation

- **API Details**: See `README.md`
- **cURL Examples**: See `CURL_COMMANDS.md`
- **Advanced Examples**: See `API_EXAMPLES.md`

---

## ✅ Checklist

- [ ] Start the server with `go run main.go`
- [ ] Create a todo with POST request
- [ ] Get all todos with GET request
- [ ] Update a todo with PUT request
- [ ] Delete a todo with DELETE request
- [ ] All operations working correctly

You're ready to go! 🎉
