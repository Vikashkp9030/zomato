# Quick Start - Expanded TODO API

## Installation & Setup

### Prerequisites
- Go 1.21 or higher
- SQLite (included with most systems)
- curl or Postman for testing

### 1. Navigate to Project
```bash
cd /Users/vikashkumarpatel/GoCourse/MyProject/todo_app
```

### 2. Install Dependencies
```bash
go mod download
go mod tidy
```

### 3. Run the Server
```bash
go run main.go
```

**Output:**
```
2026/06/11 23:37:19 Database initialized successfully
[GIN-debug] POST   /api/todos                --> todo_app/handlers.CreateTodo
[GIN-debug] GET    /api/todos                --> todo_app/handlers.GetAllTodos
... (40+ endpoints registered)
2026/06/11 23:37:19 Server starting on port 8080
[GIN-debug] Listening and serving HTTP on :8080
```

### 4. Verify It's Running
```bash
curl http://localhost:8080/health
```

**Response:**
```json
{"message":"API is running"}
```

---

## 5-Minute Quick Test

### 1. Create a User
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice",
    "email": "alice@example.com",
    "password": "secure123"
  }' | jq '.'
```

**Response:** Note the returned `id` (e.g., 1)

### 2. Create a Category
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Work",
    "color": "#EF4444"
  }' | jq '.'
```

**Response:** Note the returned `id` (e.g., 1)

### 3. Create a Tag
```bash
curl -X POST http://localhost:8080/api/tags \
  -H "Content-Type: application/json" \
  -d '{"name": "urgent"}' | jq '.'
```

**Response:** Note the returned `id` (e.g., 1)

### 4. Create a Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Complete project",
    "description": "Build and deploy new feature",
    "priority": "high",
    "status": "in_progress",
    "due_date": "2024-06-30T10:00:00Z",
    "category_id": 1,
    "user_id": 1,
    "tag_ids": [1]
  }' | jq '.'
```

### 5. Get All Todos
```bash
curl http://localhost:8080/api/todos | jq '.'
```

### 6. Get Todo Statistics
```bash
curl http://localhost:8080/api/todos/stats | jq '.'
```

### 7. Filter Todos
```bash
curl "http://localhost:8080/api/todos?status=in_progress&priority=high" | jq '.'
```

### 8. Search Todos
```bash
curl "http://localhost:8080/api/todos/search?q=complete" | jq '.'
```

---

## Core Features

### ✅ Multi-User Support
```bash
POST   /api/users              # Create user
GET    /api/users              # List users
GET    /api/users/:id          # Get user
GET    /api/users/:id/todos    # Get user's todos
PUT    /api/users/:id          # Update user
DELETE /api/users/:id          # Delete user
```

### ✅ Category Management
```bash
POST   /api/categories         # Create category
GET    /api/categories         # List categories
GET    /api/categories/:id     # Get category
GET    /api/categories/:id/todos  # Todos in category
PUT    /api/categories/:id     # Update category
DELETE /api/categories/:id     # Delete category
```

### ✅ Tag Management
```bash
POST   /api/tags               # Create tag
GET    /api/tags               # List tags
GET    /api/tags/:id           # Get tag
GET    /api/tags/:id/todos     # Todos with tag
PUT    /api/tags/:id           # Update tag
DELETE /api/tags/:id           # Delete tag
```

### ✅ Advanced Todo Management
```bash
POST   /api/todos              # Create todo
GET    /api/todos              # List todos (with filters)
GET    /api/todos/:id          # Get todo
PUT    /api/todos/:id          # Update todo
DELETE /api/todos/:id          # Delete todo
DELETE /api/todos              # Delete all
GET    /api/todos/search       # Search todos
GET    /api/todos/stats        # Get statistics
GET    /api/todos/due/:date    # Get by due date
GET    /api/todos/upcoming     # Get upcoming todos
POST   /api/todos/bulk-update  # Bulk update
POST   /api/todos/bulk-delete  # Bulk delete
```

---

## Filtering Examples

### Get High Priority Todos
```bash
curl "http://localhost:8080/api/todos?priority=high" | jq '.'
```

### Get In-Progress Todos
```bash
curl "http://localhost:8080/api/todos?status=in_progress" | jq '.'
```

### Get Incomplete Todos in Work Category
```bash
curl "http://localhost:8080/api/todos?completed=false&category_id=1" | jq '.'
```

### Get User's High Priority Todos
```bash
curl "http://localhost:8080/api/todos?user_id=1&priority=high" | jq '.'
```

### Get Todos with Specific Tag
```bash
curl "http://localhost:8080/api/todos?tag_id=1" | jq '.'
```

### Search for Todos
```bash
curl "http://localhost:8080/api/todos/search?q=project" | jq '.'
```

### Get Paginated Results (10 per page)
```bash
curl "http://localhost:8080/api/todos?page=1&limit=10" | jq '.'
```

### Get Sorted by Due Date (Ascending)
```bash
curl "http://localhost:8080/api/todos?sort_by=due_date&order=asc" | jq '.'
```

---

## Updating Examples

### Update Todo Status
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"status": "done"}' | jq '.'
```

### Mark Todo Complete
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed": true}' | jq '.'
```

### Update Todo Priority
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"priority": "low"}' | jq '.'
```

### Update Todo Tags
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"tag_ids": [1, 2, 3]}' | jq '.'
```

### Update Todo Completely
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Updated title",
    "description": "Updated description",
    "priority": "medium",
    "status": "done",
    "completed": true,
    "due_date": "2024-07-01T10:00:00Z",
    "category_id": 2,
    "tag_ids": [2, 3]
  }' | jq '.'
```

---

## Bulk Operations

### Bulk Update Status
```bash
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2, 3],
    "status": "done"
  }' | jq '.'
```

### Bulk Update Priority
```bash
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2, 3],
    "priority": "high"
  }' | jq '.'
```

### Bulk Mark Complete
```bash
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2, 3],
    "completed": true
  }' | jq '.'
```

### Bulk Delete
```bash
curl -X POST http://localhost:8080/api/todos/bulk-delete \
  -H "Content-Type: application/json" \
  -d '{"ids": [1, 2, 3]}' | jq '.'
```

---

## Statistics & Analytics

### Get Overall Statistics
```bash
curl http://localhost:8080/api/todos/stats | jq '.'
```

**Response:**
```json
{
  "total_todos": 25,
  "completed_todos": 10,
  "pending_todos": 15,
  "high_priority": 5,
  "overdue_todos": 2,
  "todos_by_category": {
    "Work": 12,
    "Personal": 13
  },
  "todos_by_status": {
    "todo": 10,
    "in_progress": 5,
    "done": 10,
    "archived": 0
  }
}
```

---

## Date-Based Queries

### Get Todos Due on Specific Date
```bash
curl "http://localhost:8080/api/todos/due/2024-06-30" | jq '.'
```

### Get Upcoming Todos (Next 7 Days)
```bash
curl "http://localhost:8080/api/todos/upcoming?days=7" | jq '.'
```

### Get Upcoming Todos (Next 30 Days)
```bash
curl "http://localhost:8080/api/todos/upcoming?days=30" | jq '.'
```

---

## API Query Parameters Reference

| Parameter | Values | Example |
|-----------|--------|---------|
| `status` | todo, in_progress, done, archived | `?status=todo` |
| `priority` | low, medium, high | `?priority=high` |
| `completed` | true, false | `?completed=false` |
| `category_id` | integer | `?category_id=1` |
| `user_id` | integer | `?user_id=1` |
| `tag_id` | integer | `?tag_id=1` |
| `search` | text | `?search=groceries` |
| `sort_by` | created_at, due_date, priority | `?sort_by=due_date` |
| `order` | asc, desc | `?order=asc` |
| `page` | integer (default: 1) | `?page=2` |
| `limit` | integer (default: 10) | `?limit=20` |

---

## Data Model Structure

### Todo
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
    {"id": 1, "name": "urgent"}
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

### Category
```json
{
  "id": 1,
  "name": "Shopping",
  "description": "Shopping tasks",
  "color": "#3B82F6",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### Tag
```json
{
  "id": 1,
  "name": "urgent",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

### User
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "created_at": 1719750000,
  "updated_at": 1719750000
}
```

---

## Environment Configuration

### Configure Port
```bash
PORT=3000 go run main.go
```

### Configure Database File
```bash
DB_PATH=my_todos.db go run main.go
```

### Configure Gin Mode
```bash
GIN_MODE=release go run main.go
```

### All Together
```bash
PORT=3000 DB_PATH=my_todos.db GIN_MODE=release go run main.go
```

---

## Development Workflow

### 1. Start Server
```bash
go run main.go
```

### 2. Create Test Data
```bash
# Create user, category, tags, todos
# (use examples above)
```

### 3. Test Endpoints
```bash
# Get all todos
curl http://localhost:8080/api/todos | jq '.'

# Filter and search
curl "http://localhost:8080/api/todos?status=todo&priority=high" | jq '.'

# View stats
curl http://localhost:8080/api/todos/stats | jq '.'
```

### 4. Update Data
```bash
# Update todo status
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"status": "done"}'
```

### 5. Clean Up
```bash
# Delete specific todo
curl -X DELETE http://localhost:8080/api/todos/1

# Delete all todos
curl -X DELETE http://localhost:8080/api/todos
```

---

## Troubleshooting

### Server Won't Start
```bash
# Check if port 8080 is in use
lsof -i :8080

# Kill process using port 8080
kill -9 <PID>

# Or use different port
PORT=3000 go run main.go
```

### Database Issues
```bash
# Reset database
rm todos.db
go run main.go  # Creates fresh database

# View database
sqlite3 todos.db ".tables"
```

### Build Errors
```bash
# Clean and rebuild
go clean
go mod tidy
go build -o todo-app
```

---

## Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Original project readme |
| `CLAUDE.md` | Development guidelines |
| `API_COMPLETE_REFERENCE.md` | Full API endpoint documentation |
| `API_TESTING_GUIDE.md` | 27+ cURL testing examples |
| `EXPANSION_SUMMARY.md` | What was added in expansion |
| `QUICK_START_EXPANDED.md` | This file - quick reference |

---

## API Endpoints Summary

**Total: 40+ Endpoints**

- 12 Todo endpoints
- 6 Category endpoints
- 6 Tag endpoints
- 6 User endpoints
- 1 Health check endpoint

See `API_COMPLETE_REFERENCE.md` for full details.

---

## Next Steps

1. **Test the API**: Follow the "5-Minute Quick Test" section
2. **Explore Endpoints**: Use examples above with different parameters
3. **Read Full Docs**: Check `API_COMPLETE_REFERENCE.md` for all details
4. **Build Features**: Use `CLAUDE.md` as development guide
5. **Deploy**: Set `GIN_MODE=release` and configure for your environment

---

## Support

For detailed information:
- **Full API Reference**: See `API_COMPLETE_REFERENCE.md`
- **Testing Examples**: See `API_TESTING_GUIDE.md`
- **What's New**: See `EXPANSION_SUMMARY.md`
- **Development**: See `CLAUDE.md`

---

Happy building! 🚀
