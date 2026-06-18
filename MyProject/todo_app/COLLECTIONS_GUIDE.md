# API Collections Guide

## Overview

This project includes **3 complete API collections** for testing the TODO API. Choose the one that best fits your workflow.

---

## 1. Postman Collection 📮

### File: `todo_api_collection.json`

**Best for:** GUI-based API testing, team collaboration, request history

### Import Steps:
1. Open **Postman**
2. Click **Import** button
3. Select `todo_api_collection.json` file
4. Collection appears in left sidebar
5. Set `base_url` variable (default: `http://localhost:8080`)
6. Click any request → **Send**

### Features:
- ✅ All 9 endpoints included
- ✅ Pre-configured JSON bodies
- ✅ Environment variables support
- ✅ Request history
- ✅ Pre-request scripts
- ✅ Response validation

### Quick Test:
1. Right-click collection → **Run collection**
2. Select "Development" environment
3. Watch all tests execute

---

## 2. Insomnia Collection 🧪

### File: `insomnia_collection.json`

**Best for:** Lightweight API testing, JSON handling, offline work

### Import Steps:
1. Open **Insomnia**
2. Click **Create** → **Import from File**
3. Select `insomnia_collection.json`
4. Set environment variables: `base_url = http://localhost:8080`
5. Click request → Press **Ctrl+Enter** (or Cmd+Enter on Mac)

### Features:
- ✅ All 9 endpoints included
- ✅ Lightweight and fast
- ✅ JSON body templates
- ✅ Environment management
- ✅ Request organization
- ✅ Beautiful response formatting

### Keyboard Shortcuts:
- `Ctrl+Enter` / `Cmd+Enter` - Send request
- `Ctrl+L` - Focus URL bar
- `Ctrl+Shift+D` - Duplicate request
- `Ctrl+B` - Toggle sidebar

---

## 3. cURL Commands 💻

### File: `CURL_COMMANDS.md`

**Best for:** Command-line work, automation, CI/CD pipelines

### Usage:
```bash
# Simple request
curl http://localhost:8080/api/todos

# With pretty print
curl http://localhost:8080/api/todos | jq '.'

# Create todo
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"My Task"}'
```

### Advantages:
- ✅ No GUI needed
- ✅ Easy to automate
- ✅ Works everywhere
- ✅ Script-friendly
- ✅ CI/CD integration
- ✅ Full control

---

## Endpoint Reference

All collections include these endpoints:

### 1. Health Check
```
GET /health
```
Verify API is running

### 2. Create Todo
```
POST /api/todos
Body: {"title": "..."}
```
Create new todo item

### 3. Get All Todos
```
GET /api/todos
```
List all todos

### 4. Get Todo by ID
```
GET /api/todos/:id
```
Get specific todo

### 5. Update Todo
```
PUT /api/todos/:id
Body: {"title": "...", "completed": bool}
```
Update todo

### 6. Update - Mark Complete
```
PUT /api/todos/:id
Body: {"completed": true}
```
Mark as done

### 7. Update - Mark Incomplete
```
PUT /api/todos/:id
Body: {"completed": false}
```
Mark as not done

### 8. Delete Todo
```
DELETE /api/todos/:id
```
Delete single todo

### 9. Delete All Todos
```
DELETE /api/todos
```
Clear all todos

---

## Quick Comparison

| Feature | Postman | Insomnia | cURL |
|---------|---------|----------|------|
| GUI | ✅ | ✅ | ❌ |
| Free | ✅ | ✅ | ✅ |
| Lightweight | ❌ | ✅ | ✅ |
| Automation | ✅ | ✅ | ✅ |
| Team Sharing | ✅ | ✅ | ✅ |
| Learning Curve | Medium | Low | Medium |
| Best For | Teams | Solo Dev | Automation |

---

## Installation Guide

### Postman
1. Visit: https://www.postman.com/downloads/
2. Download and install
3. Create account (free)
4. Import collection

### Insomnia
1. Visit: https://insomnia.rest/download
2. Download and install
3. No account required
4. Import collection

### cURL
- **macOS**: Pre-installed
- **Windows**: Pre-installed in PowerShell
- **Linux**: Install with `sudo apt-get install curl`

---

## Environment Setup

### Postman Environment Variables
- Click environment dropdown
- Edit current environment
- Add: `base_url = http://localhost:8080`
- Save

### Insomnia Environment Variables
- Click **Manage Environments** (gear icon)
- Edit "Development"
- Add: `base_url = http://localhost:8080`
- Save

### cURL Environment Variables
```bash
export BASE_URL="http://localhost:8080"
curl $BASE_URL/api/todos
```

---

## Testing Workflow

### Using Postman:
1. Import collection
2. Right-click → Run collection
3. Select environment
4. Click "Run TODO API Collection"
5. Watch tests execute in order
6. Check results

### Using Insomnia:
1. Import collection
2. Click each request individually
3. Or use Runner: `Ctrl+Alt+R`
4. Select requests to run
5. Execute

### Using cURL:
```bash
# Use the test script
./test_api.sh

# Or run commands manually
bash CURL_COMMANDS.md
```

---

## Advanced Usage

### Postman - Tests
Add tests to validate responses:
```javascript
pm.test("Status is 200", function() {
    pm.response.to.have.status(200);
});

pm.test("Response is JSON", function() {
    pm.response.to.be.json;
});
```

### Insomnia - Templating
Use response data in next request:
```
{% response 'body', 'req_1' %}
```

### cURL - Scripting
Create bash script for automation:
```bash
#!/bin/bash
curl -X POST $BASE_URL/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Task"}'
```

---

## Common Tasks

### Create Todo
**Postman:** Click "Create Todo" → Edit body → Send
**Insomnia:** Click "Create Todo" → Edit body → Ctrl+Enter
**cURL:** See CURL_COMMANDS.md → Create section

### Get All Todos
**Postman:** Click "Get All Todos" → Send
**Insomnia:** Click "Get All Todos" → Ctrl+Enter
**cURL:** `curl http://localhost:8080/api/todos`

### Update Todo
**Postman:** Click "Update Todo" → Change ID and body → Send
**Insomnia:** Click "Update Todo" → Change ID and body → Ctrl+Enter
**cURL:** Use PUT request with ID and new data

### Delete Todo
**Postman:** Click "Delete Todo" → Change ID → Send
**Insomnia:** Click "Delete Todo" → Change ID → Ctrl+Enter
**cURL:** `curl -X DELETE http://localhost:8080/api/todos/1`

---

## Tips & Tricks

### Save Responses
**Postman:** Response automatically saved in history
**Insomnia:** Timeline tab shows all requests
**cURL:** Redirect to file: `curl ... > response.json`

### Pretty Print JSON
**Postman:** Automatic formatting in Response tab
**Insomnia:** Automatic formatting
**cURL:** Add `| jq '.'` at the end

### Test with Invalid Data
All collections support testing error cases:
- Missing title in POST
- Non-existent IDs
- Invalid JSON

### Measure Performance
**Postman:** View response time in bottom bar
**Insomnia:** View response time in Timeline
**cURL:** Add `-w "@curl-format.txt"` flag

---

## Troubleshooting

### "Cannot connect to localhost:8080"
- Start the server: `go run main.go`
- Check port is not in use: `lsof -i :8080`

### "Invalid JSON" error
- Check JSON syntax in request body
- Use `jq` to validate: `echo '{}' | jq '.'`

### "Todo not found" (404)
- Verify todo ID exists
- Get all todos first to see available IDs

### Environment variables not working
- Postman: Set in environment, not global variables
- Insomnia: Set in Manage Environments
- cURL: Export before use

---

## Next Steps

1. ✅ Import your preferred collection
2. ✅ Set base_url to `http://localhost:8080`
3. ✅ Start the server: `go run main.go`
4. ✅ Send your first request
5. ✅ Create your first todo
6. ✅ Explore other endpoints

## Documentation Files

- **README.md** - Full API documentation
- **CURL_COMMANDS.md** - All cURL examples
- **API_EXAMPLES.md** - Detailed workflows
- **QUICK_START.md** - Quick getting started
- **COLLECTIONS_GUIDE.md** - This file

---

Happy Testing! 🚀
