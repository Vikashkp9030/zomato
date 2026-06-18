# TODO API - cURL Commands

Base URL: `http://localhost:8080`

## Health Check
```bash
curl -X GET http://localhost:8080/health
```

**Response:**
```json
{
  "message": "API is running"
}
```

---

## 1. Create Todo

**Single Todo:**
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries"
  }'
```

**Response:**
```json
{
  "id": 1,
  "title": "Buy groceries",
  "completed": false,
  "created_at": 1718000000,
  "updated_at": 1718000000
}
```

**Multiple Todos (examples):**
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Go"}'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Build REST API"}'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Deploy application"}'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Write tests"}'
```

---

## 2. Get All Todos

```bash
curl -X GET http://localhost:8080/api/todos
```

**Response:**
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
    "title": "Learn Go",
    "completed": false,
    "created_at": 1718000100,
    "updated_at": 1718000100
  }
]
```

---

## 3. Get Todo by ID

**Get Todo with ID 1:**
```bash
curl -X GET http://localhost:8080/api/todos/1
```

**Get Todo with ID 2:**
```bash
curl -X GET http://localhost:8080/api/todos/2
```

**Response:**
```json
{
  "id": 1,
  "title": "Buy groceries",
  "completed": false,
  "created_at": 1718000000,
  "updated_at": 1718000000
}
```

---

## 4. Update Todo

**Update Title and Mark as Completed:**
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries and milk",
    "completed": true
  }'
```

**Mark as Completed:**
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "completed": true
  }'
```

**Mark as Incomplete:**
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "completed": false
  }'
```

**Update Title Only:**
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries, milk, and eggs"
  }'
```

**Response:**
```json
{
  "id": 1,
  "title": "Buy groceries and milk",
  "completed": true,
  "created_at": 1718000000,
  "updated_at": 1718000100
}
```

---

## 5. Delete Todo

**Delete Single Todo (ID 1):**
```bash
curl -X DELETE http://localhost:8080/api/todos/1
```

**Delete Multiple Todos:**
```bash
curl -X DELETE http://localhost:8080/api/todos/2
curl -X DELETE http://localhost:8080/api/todos/3
```

**Response:**
```json
{
  "message": "Todo deleted successfully"
}
```

---

## 6. Delete All Todos

```bash
curl -X DELETE http://localhost:8080/api/todos
```

**Response:**
```json
{
  "message": "All todos deleted successfully"
}
```

---

## Testing Workflow

### 1. Check API Health
```bash
curl -X GET http://localhost:8080/health
```

### 2. Create a Few Todos
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 1"}'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 2"}'

curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Task 3"}'
```

### 3. Retrieve All Todos
```bash
curl -X GET http://localhost:8080/api/todos
```

### 4. Get Specific Todo
```bash
curl -X GET http://localhost:8080/api/todos/1
```

### 5. Update a Todo
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Updated Task 1", "completed": true}'
```

### 6. Delete a Todo
```bash
curl -X DELETE http://localhost:8080/api/todos/2
```

### 7. Verify Deletion
```bash
curl -X GET http://localhost:8080/api/todos
```

---

## Pretty Print JSON Response

Add `| jq '.'` at the end of any curl command to pretty print the JSON response:

```bash
curl -X GET http://localhost:8080/api/todos | jq '.'
```

---

## Error Cases

### Create Todo Without Title
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Response (400 Bad Request):**
```json
{
  "error": "Key: 'CreateTodoRequest.Title' Error:Field validation for 'Title' failed on the 'required' tag"
}
```

### Get Non-existent Todo
```bash
curl -X GET http://localhost:8080/api/todos/999
```

**Response (404 Not Found):**
```json
{
  "error": "Todo not found"
}
```

### Delete Non-existent Todo
```bash
curl -X DELETE http://localhost:8080/api/todos/999
```

**Response (404 Not Found):**
```json
{
  "error": "Todo not found"
}
```

---

## Using Environment Variables in cURL

Create a variable for the base URL:

```bash
BASE_URL="http://localhost:8080"

# Use it in commands
curl -X GET $BASE_URL/api/todos
curl -X POST $BASE_URL/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "New Todo"}'
```

---

## cURL Tips

- **-X**: Specify HTTP method (GET, POST, PUT, DELETE)
- **-H**: Add headers (e.g., Content-Type)
- **-d**: Request body data (must be valid JSON)
- **-i**: Include response headers in output
- **-w**: Display response time and status code
- **-s**: Silent mode (no progress bar)

Example with headers and timing:
```bash
curl -i -w "\nTime: %{time_total}s\n" http://localhost:8080/api/todos
```

---

## Postman Collection

Import the `todo_api_collection.json` file into Postman:
1. Open Postman
2. Click "Import"
3. Select the `todo_api_collection.json` file
4. Update the `base_url` variable to match your server (default: `http://localhost:8080`)
5. Use the collection to test all endpoints
