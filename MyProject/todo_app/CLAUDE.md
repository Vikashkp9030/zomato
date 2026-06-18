# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TODO App is a comprehensive RESTful API for managing todos with advanced features, built with **Go 1.21+**, **Gin web framework**, **GORM ORM**, and **SQLite**. Provides full CRUD operations for todos, categories, tags, and users with filtering, search, pagination, and analytics.

**Expansion Status**: 4x expanded! Now includes 40+ endpoints across 4 resource types (Todos, Categories, Tags, Users) with advanced features like bulk operations, filtering, pagination, search, statistics, and due date management.

## Development Commands

### Building & Running
```bash
# Run the app directly (auto-reloads on changes in development mode)
go run main.go

# Build binary
go build -o todo-app

# Run compiled binary
./todo-app
```

### Environment Variables
```bash
PORT=8080           # Server port (default: 8080)
DB_PATH=todos.db    # SQLite database file (default: todos.db)
GIN_MODE=debug      # Gin mode: debug or release (default: debug)

# Example:
PORT=3000 GIN_MODE=release go run main.go
```

### Dependency Management
```bash
# Download dependencies
go mod download

# Tidy dependencies
go mod tidy

# View dependency graph
go mod graph
```

### Testing
```bash
# Run all tests
go test ./...

# Run tests with verbose output
go test -v ./...

# Run specific test
go test -run TestFunctionName ./package

# Run tests with coverage
go test -cover ./...
```

### API Testing
Use **cURL**, **Postman** collections, or **Insomnia**:

```bash
# Create todo with priority and category
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "priority": "high",
    "status": "todo",
    "category_id": 1,
    "tag_ids": [1, 2]
  }'

# Get todos with filters and pagination
curl "http://localhost:8080/api/todos?status=todo&priority=high&page=1&limit=10"

# Search todos
curl "http://localhost:8080/api/todos/search?q=groceries"

# Get stats
curl http://localhost:8080/api/todos/stats

# Get upcoming todos (next 7 days)
curl "http://localhost:8080/api/todos/upcoming?days=7"

# Create category
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Shopping", "color": "#3B82F6"}'

# Create user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"username": "john", "email": "john@example.com", "password": "pass123"}'

# Bulk update todos
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{"ids": [1, 2, 3], "status": "done", "completed": true}'
```

## Architecture

### Directory Structure
```
todo_app/
├── main.go                    # Entry point
├── go.mod / go.sum            # Dependencies
├── config/
│   └── config.go             # Environment config
├── database/
│   └── db.go                 # GORM setup, auto-migration
├── models/
│   └── todo.go               # All models + DTOs (Todo, Category, Tag, User)
├── handlers/
│   ├── todo_handler.go       # Todo CRUD + advanced features (12 endpoints)
│   ├── category_handler.go   # Category CRUD (6 endpoints)
│   ├── tag_handler.go        # Tag CRUD (6 endpoints)
│   └── user_handler.go       # User CRUD (6 endpoints)
├── routes/
│   └── routes.go             # Route groups setup
├── middleware/
│   └── cors.go               # CORS middleware
├── API_COMPLETE_REFERENCE.md # Comprehensive API documentation
└── CLAUDE.md                 # This file
```

### Data Flow
1. **main.go**: Loads config → Initializes DB (auto-migrates all models) → Sets up Gin router → Applies CORS middleware → Registers routes → Starts server
2. **routes.go**: Groups routes into `/api/todos`, `/api/categories`, `/api/tags`, `/api/users`
3. **handlers**: Parse JSON → Validate → Execute DB queries → Return paginated/filtered responses
4. **database.go**: Exposes global `DB *gorm.DB` instance. Auto-migrates: User → Category → Tag → Todo
5. **models.go**: Defines all models (Todo, Category, Tag, User) and request/response DTOs

### Database Schema

**Todo**:
- Core fields: `ID`, `Title` (required), `Description`, `Completed` (default: false), `CreatedAt`, `UpdatedAt`, `DeletedAt` (soft delete)
- Advanced fields: `Priority` (enum: low/medium/high), `Status` (enum: todo/in_progress/done/archived), `DueDate` (nullable)
- Relationships: `CategoryID` (FK to Category), `UserID` (FK to User), `Tags` (many-to-many)

**Category**:
- `ID`, `Name` (unique), `Description`, `Color` (hex, default: #3B82F6), `CreatedAt`, `UpdatedAt`, `DeletedAt`

**Tag**:
- `ID`, `Name` (unique), `CreatedAt`, `UpdatedAt`, `DeletedAt`
- Many-to-many association with Todo (table: `todo_tags`)

**User**:
- `ID`, `Username` (unique), `Email` (unique), `Password` (SHA256 hashed), `CreatedAt`, `UpdatedAt`, `DeletedAt`

### Key Design Patterns

**Pointer Fields for Optional Updates**: `UpdateTodoRequest` uses pointers (`*string`, `*bool`) so that `nil` fields aren't overwritten in `PUT` requests. Only non-nil fields are updated.

**Pagination**: Default limit=10, default page=1. Responses include `total`, `page`, `limit`, `total_pages` for client-side navigation.

**Filtering & Search**: 
- Filtering: `status`, `priority`, `completed`, `category_id`, `user_id`, `tag_id` as query params
- Search: Full-text search across `title` and `description` (case-insensitive ILIKE)
- Sorting: `sort_by` (created_at, due_date, priority) + `order` (asc, desc)

**Relationships**: GORM `.Preload()` used to eager-load associations (Category, Tags, User) to avoid N+1 queries.

**Tag Association**: Many-to-many via `Association("Tags")`. On create, clear old tags first, then append new ones.

**Error Handling**: Consistent JSON error responses with appropriate HTTP status codes (400, 404, 500).

## API Endpoints Summary

### Todos (12 endpoints)
- CRUD: POST/GET/PUT/DELETE
- Advanced: `/search`, `/stats`, `/due/:date`, `/upcoming`, `/bulk-update`, `/bulk-delete`

### Categories (6 endpoints)
- CRUD + `/:id/todos` (get all todos in category)

### Tags (6 endpoints)
- CRUD + `/:id/todos` (get all todos with tag)

### Users (6 endpoints)
- CRUD + `/:id/todos` (get all todos assigned to user)

See `API_COMPLETE_REFERENCE.md` for full details on all 40+ endpoints.

## Common Tasks

### Adding a New Todo Field
1. Add field to `Todo` struct in `models/todo.go` with GORM tag (e.g., `Color string`)
2. Update `CreateTodoRequest` and `UpdateTodoRequest` if field should be mutable
3. Update relevant handlers (CreateTodo, UpdateTodo) to accept/process the new field
4. Delete `todos.db` to reset schema (auto-migration will create new column)
5. Test with cURL/Postman

**Example**: Add `DueTime` field for time-of-day:
```go
// models/todo.go
type Todo struct {
    // ... existing fields ...
    DueTime    *string   `json:"due_time"` // e.g., "14:30"
}

type CreateTodoRequest struct {
    // ... existing fields ...
    DueTime    *string   `json:"due_time"`
}

// handlers/todo_handler.go - in CreateTodo()
if req.DueTime != nil {
    updates["due_time"] = *req.DueTime
}
```

### Adding a New Endpoint
1. Add handler func in appropriate handler file (signature: `func Name(c *gin.Context)`)
2. Add route in `routes/routes.go` under appropriate group
3. Test with cURL

**Example**: Add `GET /api/todos/by-priority/:priority` to list todos by priority:
```go
// handlers/todo_handler.go
func GetTodosByPriority(c *gin.Context) {
    priority := c.Param("priority")
    var todos []models.Todo
    
    if err := database.DB.Preload("Category").Preload("Tags").
        Where("priority = ?", priority).Find(&todos).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch todos"})
        return
    }
    
    c.JSON(http.StatusOK, todos)
}

// routes/routes.go - in SetupRoutes()
todos.GET("/by-priority/:priority", handlers.GetTodosByPriority)
```

### Database Reset
```bash
rm todos.db        # Delete SQLite file
go run main.go     # Auto-migration creates fresh schema
```

### Understanding Pagination
Default page=1, limit=10. Response includes:
- `total`: Total record count
- `page`: Current page
- `limit`: Records per page
- `total_pages`: Calculated ceiling(total / limit)

Client uses `page` and `limit` to navigate (e.g., next: `page + 1`).

## Dependencies & Stack

- **gin-gonic/gin** (v1.9.1): HTTP router/middleware engine
- **gorm.io/gorm** (v1.25.2): ORM with relationships support
- **gorm.io/driver/sqlite** (v1.5.1): SQLite driver
- **Go 1.21+**: Language and runtime

## Future Improvements

1. **Authentication & Authorization**: JWT middleware, role-based access control
2. **Database Upgrade**: PostgreSQL for production (easier scaling, full-text search)
3. **Structured Logging**: Replace `log` package with `zap` or `logrus`
4. **Unit Tests**: Test handlers, database layer, business logic
5. **Input Validation**: Length limits, email validation, enum checks
6. **API Documentation**: Swagger/OpenAPI integration
7. **Caching**: Redis for frequently accessed data
8. **Rate Limiting**: Prevent abuse
9. **Soft Delete Handling**: Ensure queries skip soft-deleted records
10. **Frontend**: React/Vue dashboard

## Notes

- **Password Hashing**: Currently uses SHA256 (demo purposes). Use bcrypt or argon2 for production.
- **CORS**: Currently allows all origins. Restrict to specific domains in production.
- **Timestamps**: Unix timestamps (int64). Consider ISO8601 strings for JSON compatibility.
- **Error Messages**: Currently expose internal errors. Sanitize in production.
- **Soft Deletes**: Always remember that soft-deleted records need to be filtered out in queries (GORM handles this by default).
