# API Testing Guide

This guide shows how to test all 40+ API endpoints using cURL commands.

## Setup

Start the server:
```bash
go run main.go
```

The API will be available at `http://localhost:8080`

---

## User Management (6 endpoints)

### 1. Create User
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "secure123"
  }' | jq '.'
```

**Expected Response:**
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
```bash
curl http://localhost:8080/api/users | jq '.'
```

### 3. Get User by ID
```bash
curl http://localhost:8080/api/users/1 | jq '.'
```

### 4. Get User's Todos
```bash
curl http://localhost:8080/api/users/1/todos | jq '.'
```

### 5. Update User
```bash
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe_updated",
    "email": "newemail@example.com"
  }' | jq '.'
```

### 6. Delete User
```bash
curl -X DELETE http://localhost:8080/api/users/1 | jq '.'
```

---

## Category Management (6 endpoints)

### 1. Create Category
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Shopping",
    "description": "Shopping related tasks",
    "color": "#3B82F6"
  }' | jq '.'
```

### 2. Create Another Category
```bash
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Work",
    "description": "Work related tasks",
    "color": "#EF4444"
  }' | jq '.'
```

### 3. Get All Categories
```bash
curl http://localhost:8080/api/categories | jq '.'
```

### 4. Get Category by ID
```bash
curl http://localhost:8080/api/categories/1 | jq '.'
```

### 5. Get Todos in Category
```bash
curl http://localhost:8080/api/categories/1/todos | jq '.'
```

### 6. Update Category
```bash
curl -X PUT http://localhost:8080/api/categories/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Shopping Updated",
    "color": "#10B981"
  }' | jq '.'
```

---

## Tag Management (6 endpoints)

### 1. Create Tag
```bash
curl -X POST http://localhost:8080/api/tags \
  -H "Content-Type: application/json" \
  -d '{"name": "urgent"}' | jq '.'
```

### 2. Create More Tags
```bash
curl -X POST http://localhost:8080/api/tags \
  -H "Content-Type: application/json" \
  -d '{"name": "food"}' | jq '.'

curl -X POST http://localhost:8080/api/tags \
  -H "Content-Type: application/json" \
  -d '{"name": "grocery"}' | jq '.'
```

### 3. Get All Tags
```bash
curl http://localhost:8080/api/tags | jq '.'
```

### 4. Get Tag by ID
```bash
curl http://localhost:8080/api/tags/1 | jq '.'
```

### 5. Get Todos with Tag
```bash
curl http://localhost:8080/api/tags/1/todos | jq '.'
```

### 6. Update Tag
```bash
curl -X PUT http://localhost:8080/api/tags/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "urgent-high"}' | jq '.'
```

---

## Todo Management (12 endpoints)

### 1. Create Simple Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries"
  }' | jq '.'
```

### 2. Create Todo with All Fields
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy milk and eggs",
    "description": "Get fresh milk and eggs from store",
    "priority": "high",
    "status": "todo",
    "due_date": "2024-06-30T10:00:00Z",
    "category_id": 1,
    "tag_ids": [1, 2],
    "user_id": 1
  }' | jq '.'
```

### 3. Create More Todos for Testing
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Complete project",
    "priority": "high",
    "status": "in_progress",
    "category_id": 2,
    "user_id": 1
  }' | jq '.'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Review code",
    "priority": "medium",
    "status": "todo",
    "category_id": 2
  }' | jq '.'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Go for a walk",
    "priority": "low",
    "status": "todo",
    "completed": false
  }' | jq '.'
```

### 4. Get All Todos
```bash
curl http://localhost:8080/api/todos | jq '.'
```

### 5. Get Todos with Pagination
```bash
curl "http://localhost:8080/api/todos?page=1&limit=2" | jq '.'
```

### 6. Filter Todos by Status
```bash
curl "http://localhost:8080/api/todos?status=todo" | jq '.'
```

### 7. Filter Todos by Priority
```bash
curl "http://localhost:8080/api/todos?priority=high" | jq '.'
```

### 8. Filter by Multiple Criteria
```bash
curl "http://localhost:8080/api/todos?status=todo&priority=high&page=1&limit=5" | jq '.'
```

### 9. Filter by Category
```bash
curl "http://localhost:8080/api/todos?category_id=1" | jq '.'
```

### 10. Filter by User
```bash
curl "http://localhost:8080/api/todos?user_id=1" | jq '.'
```

### 11. Filter by Tag
```bash
curl "http://localhost:8080/api/todos?tag_id=1" | jq '.'
```

### 12. Filter by Completion Status
```bash
curl "http://localhost:8080/api/todos?completed=false" | jq '.'
```

### 13. Get Todo by ID
```bash
curl http://localhost:8080/api/todos/1 | jq '.'
```

### 14. Update Todo (Partial)
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries and milk",
    "completed": true
  }' | jq '.'
```

### 15. Update Todo Status
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "status": "done"
  }' | jq '.'
```

### 16. Update Todo Priority
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "priority": "low"
  }' | jq '.'
```

### 17. Update Todo with Tags
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "tag_ids": [1, 3]
  }' | jq '.'
```

### 18. Search Todos
```bash
curl "http://localhost:8080/api/todos/search?q=buy" | jq '.'
```

### 19. Get Todo Statistics
```bash
curl http://localhost:8080/api/todos/stats | jq '.'
```

### 20. Get Todos by Due Date
```bash
curl "http://localhost:8080/api/todos/due/2024-06-30" | jq '.'
```

### 21. Get Upcoming Todos (Next 7 Days)
```bash
curl "http://localhost:8080/api/todos/upcoming?days=7" | jq '.'
```

### 22. Get Upcoming Todos (Next 30 Days)
```bash
curl "http://localhost:8080/api/todos/upcoming?days=30" | jq '.'
```

### 23. Bulk Update Todos
```bash
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2],
    "status": "done",
    "completed": true
  }' | jq '.'
```

### 24. Bulk Update with Priority
```bash
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [3, 4],
    "priority": "high"
  }' | jq '.'
```

### 25. Delete Todo
```bash
curl -X DELETE http://localhost:8080/api/todos/4 | jq '.'
```

### 26. Bulk Delete Todos
```bash
curl -X POST http://localhost:8080/api/todos/bulk-delete \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [2, 3]
  }' | jq '.'
```

### 27. Delete All Todos
```bash
curl -X DELETE http://localhost:8080/api/todos | jq '.'
```

---

## Advanced Testing Scenarios

### Scenario 1: Complete Task Management Workflow

```bash
# 1. Create users
USER1=$(curl -s -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"username": "alice", "email": "alice@example.com", "password": "pass123"}' | jq '.id')

USER2=$(curl -s -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"username": "bob", "email": "bob@example.com", "password": "pass123"}' | jq '.id')

# 2. Create categories
CAT1=$(curl -s -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Work", "color": "#EF4444"}' | jq '.id')

CAT2=$(curl -s -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Personal", "color": "#3B82F6"}' | jq '.id')

# 3. Create tags
TAG1=$(curl -s -X POST http://localhost:8080/api/tags \
  -H "Content-Type: application/json" \
  -d '{"name": "urgent"}' | jq '.id')

# 4. Create todos
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Finish report",
    "priority": "high",
    "status": "in_progress",
    "category_id": '${CAT1}',
    "user_id": '${USER1}',
    "tag_ids": ['${TAG1}']
  }' | jq '.'

# 5. View stats
curl http://localhost:8080/api/todos/stats | jq '.'

# 6. Get user's todos
curl http://localhost:8080/api/users/${USER1}/todos | jq '.'
```

### Scenario 2: Search and Filter

```bash
# Search for todos containing "finish"
curl "http://localhost:8080/api/todos/search?q=finish" | jq '.'

# Get high priority todos in work category
curl "http://localhost:8080/api/todos?category_id=1&priority=high" | jq '.'

# Get incomplete work items sorted by due date
curl "http://localhost:8080/api/todos?status=todo&sort_by=due_date&order=asc" | jq '.'
```

### Scenario 3: Bulk Operations

```bash
# Mark multiple todos as done
curl -X POST http://localhost:8080/api/todos/bulk-update \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2, 3],
    "status": "done",
    "completed": true,
    "priority": "medium"
  }' | jq '.'

# Delete multiple completed todos
curl -X POST http://localhost:8080/api/todos/bulk-delete \
  -H "Content-Type: application/json" \
  -d '{
    "ids": [1, 2]
  }' | jq '.'
```

---

## Tips

1. **Use jq for pretty printing**: Pipe all responses to `| jq '.'`
2. **Store IDs in variables**: Use `$(curl ... | jq '.id')` to get ID
3. **Test filters**: Try combining multiple filters
4. **Check stats**: Use `/stats` endpoint to verify changes
5. **Use -v flag**: Add `-v` to curl for debugging HTTP headers and status codes

---

## Error Testing

### Test 400 Bad Request
```bash
# Missing required field
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"description": "No title"}' | jq '.'
```

### Test 404 Not Found
```bash
# Get non-existent todo
curl http://localhost:8080/api/todos/999 | jq '.'

# Get non-existent user
curl http://localhost:8080/api/users/999 | jq '.'
```

### Test 500 Internal Server Error
```bash
# Try to create duplicate category (if name is unique)
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Work"}' | jq '.'

curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name": "Work"}' | jq '.'
```

---

## Performance Testing

Monitor response times:
```bash
# Time the request
curl -w "\nTime: %{time_total}s\n" http://localhost:8080/api/todos/stats
```

---

Enjoy testing the API!
