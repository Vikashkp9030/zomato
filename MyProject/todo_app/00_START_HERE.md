# 🚀 TODO API - START HERE

## Welcome! 👋

You now have a **complete, production-ready TODO API** with:
- ✅ Full CRUD operations
- ✅ SQLite database
- ✅ 3 different API collection formats
- ✅ Complete documentation

---

## ⚡ Get Running in 60 Seconds

### Step 1: Start Server (30 seconds)
```bash
cd /Users/vikashkumarpatel/GoCourse/MyProject/todo_app
go run main.go
```

### Step 2: Test API (30 seconds) - Choose ONE:

**Option A: Using cURL (CLI)**
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"My First Todo"}'
```

**Option B: Using Postman (GUI)**
1. Download: https://www.postman.com/downloads/
2. Import: `todo_api_collection.json`
3. Click "Create Todo" → "Send"

**Option C: Using Insomnia (GUI)**
1. Download: https://insomnia.rest/download
2. Import: `insomnia_collection.json`
3. Click "Create Todo" → Ctrl+Enter

**Option D: Using Test Script**
```bash
chmod +x test_api.sh
./test_api.sh
```

---

## 📚 What You Have

### Collections (Pick Your Tool)
| File | Tool | Best For |
|------|------|----------|
| `todo_api_collection.json` | Postman | Teams, GUI |
| `insomnia_collection.json` | Insomnia | Solo, Lightweight |
| `CURL_COMMANDS.md` | cURL | CLI, Automation |

### Documentation (In Order)
1. **QUICK_START.md** - Setup guide (5 min)
2. **README.md** - Full API reference
3. **CURL_COMMANDS.md** - cURL examples
4. **API_EXAMPLES.md** - Workflows & patterns
5. **COLLECTIONS_GUIDE.md** - Tool guides
6. **INDEX.md** - Project overview

---

## 🔌 API Endpoints (All Working)

```
GET    http://localhost:8080/health              ← Health check
POST   http://localhost:8080/api/todos           ← Create
GET    http://localhost:8080/api/todos           ← Get all
GET    http://localhost:8080/api/todos/1         ← Get one
PUT    http://localhost:8080/api/todos/1         ← Update
DELETE http://localhost:8080/api/todos/1         ← Delete
DELETE http://localhost:8080/api/todos           ← Delete all
```

---

## 📂 Project Structure

```
todo_app/
├── 🎯 Collections (Import these)
│   ├── todo_api_collection.json         (Postman)
│   └── insomnia_collection.json         (Insomnia)
│
├── 📖 Documentation (Read these)
│   ├── 00_START_HERE.md                 ← You are here
│   ├── QUICK_START.md                   ← Read next
│   ├── README.md
│   ├── CURL_COMMANDS.md
│   ├── API_EXAMPLES.md
│   ├── COLLECTIONS_GUIDE.md
│   └── INDEX.md
│
├── 🧪 Test Scripts
│   └── test_api.sh
│
├── 💻 Source Code
│   ├── main.go
│   ├── models/todo.go
│   ├── handlers/todo_handler.go
│   ├── routes/routes.go
│   ├── database/db.go
│   ├── config/config.go
│   └── middleware/cors.go
│
└── 📦 Dependency Files
    ├── go.mod
    └── go.sum
```

---

## 🎯 Next Steps (Choose Your Path)

### Path 1: I Want to Use Postman
1. Download Postman from https://www.postman.com/downloads/
2. Click "Import" in Postman
3. Select `todo_api_collection.json`
4. See all requests ready to use!

### Path 2: I Want to Use Insomnia
1. Download Insomnia from https://insomnia.rest/download
2. Create workspace
3. Import `insomnia_collection.json`
4. Start testing!

### Path 3: I Want to Use cURL
1. Open `CURL_COMMANDS.md`
2. Copy any command
3. Paste in terminal
4. See response!

### Path 4: I Want to Learn the Code
1. Read `README.md` for API overview
2. Check `API_EXAMPLES.md` for workflows
3. Browse source code in `/models`, `/handlers`, `/routes`

---

## 🧪 Quick Test Examples

### Create a Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Buy groceries"}'
```

### Get All Todos
```bash
curl http://localhost:8080/api/todos
```

### Mark as Done
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'
```

### Delete a Todo
```bash
curl -X DELETE http://localhost:8080/api/todos/1
```

---

## ✨ Features

✅ **Full CRUD** - Create, Read, Update, Delete  
✅ **SQLite Database** - Automatic creation  
✅ **GORM ORM** - Type-safe database queries  
✅ **Gin Framework** - Fast and lightweight  
✅ **CORS Enabled** - Works with frontends  
✅ **Clean Structure** - Easy to extend  
✅ **Error Handling** - Proper HTTP status codes  
✅ **Configuration** - Environment variables  

---

## 📊 Supported Operations

| Operation | Method | Example |
|-----------|--------|---------|
| Create | POST | `POST /api/todos` + body |
| Read All | GET | `GET /api/todos` |
| Read One | GET | `GET /api/todos/1` |
| Update | PUT | `PUT /api/todos/1` + body |
| Delete One | DELETE | `DELETE /api/todos/1` |
| Delete All | DELETE | `DELETE /api/todos` |

---

## 🛠️ Common Commands

```bash
# Start server
go run main.go

# Build binary
go build -o todo_app

# Run binary
./todo_app

# Run tests
./test_api.sh

# Check all todos
curl http://localhost:8080/api/todos | jq '.'

# With custom port
PORT=3000 go run main.go
```

---

## 💾 Database

- **Type**: SQLite
- **File**: `todos.db` (auto-created)
- **Location**: Project root
- **Reset**: Delete file & restart

---

## ❓ Need Help?

| Question | Answer |
|----------|--------|
| How do I start? | Run `go run main.go` |
| Which collection to use? | Try Postman or Insomnia first |
| How do I test endpoints? | Use curl or import collection |
| Where's the database? | `todos.db` in project root |
| How do I change port? | `PORT=3000 go run main.go` |
| Can I add features? | Yes! Add handlers & routes |

---

## 📚 Files You Should Know

| File | Contains | Size |
|------|----------|------|
| `QUICK_START.md` | 5-min setup guide | 4.3K |
| `README.md` | Full API docs | 4.7K |
| `CURL_COMMANDS.md` | All cURL examples | 5.8K |
| `API_EXAMPLES.md` | Workflows & patterns | 8.1K |
| `COLLECTIONS_GUIDE.md` | Tool guides | 7.4K |
| `todo_api_collection.json` | Postman file | 4.9K |
| `insomnia_collection.json` | Insomnia file | 6.4K |

---

## 🎉 Ready?

### Fastest Start (30 seconds)
```bash
go run main.go
# In another terminal
curl http://localhost:8080/api/todos
```

### Recommended Start (5 minutes)
1. Read `QUICK_START.md`
2. Run `go run main.go`
3. Import collection or use cURL
4. Create your first todo!

---

## 🚀 You're All Set!

Everything is ready. Pick a tool above and start building!

**Questions?** Check the documentation files - they have everything.

Happy coding! 🎊

---

**Next Document**: Read → `QUICK_START.md`
