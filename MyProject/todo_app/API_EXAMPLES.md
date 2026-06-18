# TODO API - Quick Examples

## Setup

Start the server:
```bash
cd /Users/vikashkumarpatel/GoCourse/MyProject/todo_app
go run main.go
```

The API will be available at: `http://localhost:8080`

---

## Example 1: Complete CRUD Workflow

### Step 1: Check API Health
```bash
curl http://localhost:8080/health
```
Output:
```json
{"message":"API is running"}
```

### Step 2: Create 3 Todos
```bash
# Todo 1
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Go"}'

# Todo 2
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Build REST API"}'

# Todo 3
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Deploy to production"}'
```

### Step 3: Get All Todos
```bash
curl http://localhost:8080/api/todos
```

### Step 4: Get Specific Todo (ID: 1)
```bash
curl http://localhost:8080/api/todos/1
```

### Step 5: Mark Todo 1 as Complete
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'
```

### Step 6: Update Todo 2 Title
```bash
curl -X PUT http://localhost:8080/api/todos/2 \
  -H "Content-Type: application/json" \
  -d '{"title":"Build REST API with Gin"}'
```

### Step 7: Delete Todo 3
```bash
curl -X DELETE http://localhost:8080/api/todos/3
```

### Step 8: Verify Final State
```bash
curl http://localhost:8080/api/todos
```

---

## Example 2: Using JSON Pretty Print

Add `| jq '.'` to pretty print responses:

```bash
curl http://localhost:8080/api/todos | jq '.'
```

Example output:
```json
[
  {
    "id": 1,
    "title": "Learn Go",
    "completed": true,
    "created_at": 1718000000,
    "updated_at": 1718000100
  },
  {
    "id": 2,
    "title": "Build REST API with Gin",
    "completed": false,
    "created_at": 1718000050,
    "updated_at": 1718000150
  }
]
```

---

## Example 3: Save Todo ID to Variable

Get the created todo and save its ID:

```bash
# Create a todo and save response
RESPONSE=$(curl -s -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"New Task"}')

# Extract ID using jq
TODO_ID=$(echo $RESPONSE | jq '.id')

# Use the ID in subsequent requests
curl http://localhost:8080/api/todos/$TODO_ID
```

---

## Example 4: Bulk Operations

### Create Multiple Todos
```bash
#!/bin/bash

TODOS=("Learn Go" "Build API" "Write Tests" "Deploy App" "Monitor Logs")

for todo in "${TODOS[@]}"; do
  curl -s -X POST http://localhost:8080/api/todos \
    -H "Content-Type: application/json" \
    -d "{\"title\":\"$todo\"}" > /dev/null
  echo "Created: $todo"
done

echo "All todos created!"
```

### Mark All Todos as Complete
```bash
#!/bin/bash

# Get all todos
TODOS=$(curl -s http://localhost:8080/api/todos)

# Extract IDs and update each one
echo "$TODOS" | jq -r '.[] | .id' | while read id; do
  curl -s -X PUT http://localhost:8080/api/todos/$id \
    -H "Content-Type: application/json" \
    -d '{"completed":true}' > /dev/null
  echo "Marked todo $id as complete"
done
```

---

## Example 5: Testing Error Cases

### Missing Required Field
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{}'
```
Response (400):
```json
{"error":"Key: 'CreateTodoRequest.Title' Error:Field validation for 'Title' failed on the 'required' tag"}
```

### Non-existent Todo
```bash
curl http://localhost:8080/api/todos/999
```
Response (404):
```json
{"error":"Todo not found"}
```

---

## Example 6: Using Environment Variables

```bash
# Set base URL
BASE_URL="http://localhost:8080"
API_URL="$BASE_URL/api/todos"

# Create
curl -X POST $API_URL \
  -H "Content-Type: application/json" \
  -d '{"title":"Task from variable"}'

# Get all
curl $API_URL

# Get specific
curl $API_URL/1

# Update
curl -X PUT $API_URL/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'

# Delete
curl -X DELETE $API_URL/1
```

---

## Example 7: Using Postman

1. **Import Collection**
   - Open Postman
   - Click "Import"
   - Select `todo_api_collection.json`

2. **Set Environment Variable**
   - Click on environment selector
   - Edit the "Development" environment
   - Set `base_url` to `http://localhost:8080`

3. **Send Requests**
   - Click on any request in the collection
   - Click "Send"
   - View response in the Response tab

---

## Example 8: Using Insomnia

1. **Import Collection**
   - Open Insomnia
   - Click "Create" → "Import from URL/File"
   - Select `insomnia_collection.json`

2. **Set Environment Variables**
   - Click "Manage Environments"
   - Set `base_url` to `http://localhost:8080`

3. **Send Requests**
   - Click on any request
   - Press `Ctrl+Enter` to send
   - View response in the Response panel

---

## Example 9: Request/Response Examples

### Create Todo
**Request:**
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Docker"}'
```

**Response (201 Created):**
```json
{
  "id": 4,
  "title": "Learn Docker",
  "completed": false,
  "created_at": 1718000200,
  "updated_at": 1718000200
}
```

### Update Todo with All Fields
**Request:**
```bash
curl -X PUT http://localhost:8080/api/todos/4 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Docker and Kubernetes",
    "completed": true
  }'
```

**Response (200 OK):**
```json
{
  "id": 4,
  "title": "Learn Docker and Kubernetes",
  "completed": true,
  "created_at": 1718000200,
  "updated_at": 1718000300
}
```

### Delete Todo
**Request:**
```bash
curl -X DELETE http://localhost:8080/api/todos/4
```

**Response (200 OK):**
```json
{
  "message": "Todo deleted successfully"
}
```

---

## Example 10: Full Test Script

Create a file `test_full.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:8080"
API_URL="$BASE_URL/api/todos"

echo "🚀 Starting TODO API Tests"
echo ""

# Health check
echo "1️⃣  Health Check"
curl -s $BASE_URL/health | jq '.'
echo ""

# Create todos
echo "2️⃣  Creating Todos"
RESPONSE1=$(curl -s -X POST $API_URL -H "Content-Type: application/json" -d '{"title":"Task 1"}')
ID1=$(echo $RESPONSE1 | jq '.id')
echo "Created Todo 1 (ID: $ID1)"

RESPONSE2=$(curl -s -X POST $API_URL -H "Content-Type: application/json" -d '{"title":"Task 2"}')
ID2=$(echo $RESPONSE2 | jq '.id')
echo "Created Todo 2 (ID: $ID2)"

RESPONSE3=$(curl -s -X POST $API_URL -H "Content-Type: application/json" -d '{"title":"Task 3"}')
ID3=$(echo $RESPONSE3 | jq '.id')
echo "Created Todo 3 (ID: $ID3)"
echo ""

# Get all
echo "3️⃣  Getting All Todos"
curl -s $API_URL | jq '.'
echo ""

# Update
echo "4️⃣  Updating Todo 1"
curl -s -X PUT $API_URL/$ID1 -H "Content-Type: application/json" -d '{"completed":true}' | jq '.'
echo ""

# Delete
echo "5️⃣  Deleting Todo 2"
curl -s -X DELETE $API_URL/$ID2 | jq '.'
echo ""

# Final list
echo "6️⃣  Final Todos List"
curl -s $API_URL | jq '.'
echo ""

echo "✅ Tests completed!"
```

Run it:
```bash
chmod +x test_full.sh
./test_full.sh
```

---

## Quick Reference Table

| Operation | Method | Endpoint | Body |
|-----------|--------|----------|------|
| Health Check | GET | `/health` | - |
| Create | POST | `/api/todos` | `{"title":"..."}` |
| Get All | GET | `/api/todos` | - |
| Get One | GET | `/api/todos/:id` | - |
| Update | PUT | `/api/todos/:id` | `{"title":"...","completed":bool}` |
| Delete One | DELETE | `/api/todos/:id` | - |
| Delete All | DELETE | `/api/todos` | - |

---

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK (GET, PUT, DELETE success) |
| 201 | Created (POST success) |
| 400 | Bad Request (validation error) |
| 404 | Not Found |
| 500 | Internal Server Error |

---

## Tips & Tricks

1. **Save responses to file:**
   ```bash
   curl http://localhost:8080/api/todos > todos.json
   ```

2. **Check response headers:**
   ```bash
   curl -i http://localhost:8080/api/todos
   ```

3. **Measure response time:**
   ```bash
   curl -w "@curl-format.txt" -o /dev/null -s http://localhost:8080/api/todos
   ```

4. **Add custom headers:**
   ```bash
   curl -H "X-Custom-Header: value" http://localhost:8080/api/todos
   ```

5. **Use verbose mode:**
   ```bash
   curl -v http://localhost:8080/api/todos
   ```
