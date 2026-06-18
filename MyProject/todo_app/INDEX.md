# TODO API - Complete Project Index

## 📋 Project Overview

A production-ready TODO application with CRUD operations built using:
- **Framework**: Gin (Go web framework)
- **Database**: SQLite with GORM ORM
- **Architecture**: Clean folder structure with separation of concerns

---

## 📂 Project Structure

```
todo_app/
│
├── 📄 Source Code
│   ├── main.go                  # Application entry point
│   ├── go.mod & go.sum          # Dependency management
│   │
│   ├── 📁 models/
│   │   └── todo.go              # Todo model & request/response structs
│   │
│   ├── 📁 handlers/
│   │   └── todo_handler.go      # CRUD handler functions
│   │
│   ├── 📁 routes/
│   │   └── routes.go            # API route definitions
│   │
│   ├── 📁 database/
│   │   └── db.go                # Database initialization & migration
│   │
│   ├── 📁 config/
│   │   └── config.go            # Configuration management
│   │
│   ├── 📁 middleware/
│   │   └── cors.go              # CORS middleware
│   │
│   └── 📁 .gitignore            # Git ignore rules
│
├── 📚 Documentation
│   ├── README.md                # Full API documentation
│   ├── QUICK_START.md           # Quick start guide (5 min setup)
│   ├── CURL_COMMANDS.md         # cURL examples for all endpoints
│   ├── API_EXAMPLES.md          # Detailed workflows & examples
│   ├── COLLECTIONS_GUIDE.md     # Guide to collections & tools
│   └── INDEX.md                 # This file
│
├── 🧪 API Collections
│   ├── todo_api_collection.json     # Postman collection
│   ├── insomnia_collection.json     # Insomnia collection
│   │
│   ├── 🚀 Test Scripts
│   │   ├── test_api.sh              # Automated API test script
│   │   └── CURL_COMMANDS.md         # Manual cURL commands
│
└── 📦 Build Artifacts
    └── todo_app                 # Compiled binary (after `go build`)
```

---

## 🚀 Quick Start (Choose One)

### Option 1: Fastest (5 minutes)
```bash
cd /Users/vikashkumarpatel/GoCourse/MyProject/todo_app
go run main.go

# In another terminal
curl http://localhost:8080/api/todos
```

### Option 2: Using Postman
1. Download: https://www.postman.com/downloads/
2. Import `todo_api_collection.json`
3. Click any request → Send

### Option 3: Using Insomnia
1. Download: https://insomnia.rest/download
2. Import `insomnia_collection.json`
3. Click any request → Ctrl+Enter

See **QUICK_START.md** for detailed steps.

---

## 📖 Documentation Map

| Document | Best For | Time |
|----------|----------|------|
| **QUICK_START.md** | Getting started immediately | 5 min |
| **README.md** | Full API reference & details | 10 min |
| **CURL_COMMANDS.md** | Command-line testing | 15 min |
| **API_EXAMPLES.md** | Learning workflows & patterns | 20 min |
| **COLLECTIONS_GUIDE.md** | Using Postman/Insomnia tools | 10 min |
| **INDEX.md** | Project structure overview | 5 min |

---

## 🔌 API Endpoints

### Base URL
```
http://localhost:8080
```

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/api/todos` | Create todo |
| GET | `/api/todos` | Get all todos |
| GET | `/api/todos/:id` | Get todo by ID |
| PUT | `/api/todos/:id` | Update todo |
| DELETE | `/api/todos/:id` | Delete todo |
| DELETE | `/api/todos` | Delete all todos |

See **CURL_COMMANDS.md** for request/response examples.

---

## 🛠️ Common Commands

### Setup & Build
```bash
# Download dependencies
go mod tidy

# Build binary
go build -o todo_app

# Run from source
go run main.go

# Run binary
./todo_app
```

### Testing
```bash
# Run automated tests
./test_api.sh

# Single request
curl http://localhost:8080/api/todos

# Pretty print response
curl http://localhost:8080/api/todos | jq '.'
```

### Configuration
```bash
# Custom port
PORT=3000 go run main.go

# Custom database path
DB_PATH=custom.db go run main.go

# Production mode
GIN_MODE=release go run main.go
```

---

## 💾 Database

### Location
- **File**: `todos.db` (SQLite)
- **Created**: Automatically on first run
- **Reset**: Delete file and restart app

### Schema
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

### Inspect Database
```bash
sqlite3 todos.db "SELECT * FROM todos;"
```

---

## 📊 Request/Response Examples

### Create Todo
**Request:**
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Go"}'
```

**Response (201):**
```json
{
  "id": 1,
  "title": "Learn Go",
  "completed": false,
  "created_at": 1718000000,
  "updated_at": 1718000000
}
```

### Get All Todos
**Request:**
```bash
curl http://localhost:8080/api/todos
```

**Response (200):**
```json
[
  {
    "id": 1,
    "title": "Learn Go",
    "completed": false,
    "created_at": 1718000000,
    "updated_at": 1718000000
  }
]
```

See **README.md** for all endpoints.

---

## 🔧 Testing Tools

### Postman (GUI)
- **File**: `todo_api_collection.json`
- **Download**: https://www.postman.com/downloads/
- **Setup**: Import file → Set base_url
- **Best For**: Team collaboration, GUI testing

### Insomnia (GUI)
- **File**: `insomnia_collection.json`
- **Download**: https://insomnia.rest/download
- **Setup**: Import file → Set environment
- **Best For**: Solo developers, lightweight

### cURL (CLI)
- **File**: `CURL_COMMANDS.md`
- **Pre-installed**: macOS, Windows, Linux
- **Best For**: Automation, CI/CD, scripts

---

## 📝 Code Files Explained

### main.go
Entry point that:
- Initializes database
- Sets up middleware
- Defines routes
- Starts server on port 8080

### models/todo.go
Defines:
- `Todo` struct (database model)
- `CreateTodoRequest` (POST request)
- `UpdateTodoRequest` (PUT request)

### handlers/todo_handler.go
Contains functions:
- `CreateTodo` - POST handler
- `GetAllTodos` - GET all
- `GetTodoByID` - GET by ID
- `UpdateTodo` - PUT handler
- `DeleteTodo` - DELETE single
- `DeleteAllTodos` - DELETE all

### routes/routes.go
Sets up all API routes:
- Groups under `/api/todos`
- Maps handlers to methods

### database/db.go
Handles:
- Database connection
- Auto-migration
- Schema initialization

### config/config.go
Loads environment variables:
- `PORT` (default: 8080)
- `DB_PATH` (default: todos.db)
- `GIN_MODE` (default: debug)

### middleware/cors.go
Enables CORS for:
- Cross-origin requests
- POST, GET, PUT, DELETE
- All content types

---

## ✅ Checklist

Setup:
- [ ] Clone/navigate to project
- [ ] Run `go mod tidy`
- [ ] Run `go run main.go`

Testing (choose one):
- [ ] Use cURL with `CURL_COMMANDS.md`
- [ ] Import to Postman
- [ ] Import to Insomnia
- [ ] Run `./test_api.sh`

Features:
- [ ] Create a todo
- [ ] Read all todos
- [ ] Read single todo
- [ ] Update todo
- [ ] Delete todo

---

## 🎯 Next Steps

1. **Understand**: Read **QUICK_START.md** (5 min)
2. **Setup**: Run `go run main.go` (1 min)
3. **Test**: Use one of three methods (5 min)
4. **Learn**: Read **README.md** for API details (10 min)
5. **Explore**: Check **API_EXAMPLES.md** for workflows (15 min)

---

## 🤔 FAQ

**Q: How do I change the port?**
A: `PORT=3000 go run main.go`

**Q: Where's my data stored?**
A: SQLite file at `todos.db`

**Q: How do I reset the database?**
A: Delete `todos.db` file and restart

**Q: Can I use this in production?**
A: Yes, build with `go build` and run the binary

**Q: How do I add more endpoints?**
A: Add handler in `handlers/`, add route in `routes/`

See **COLLECTIONS_GUIDE.md** for more FAQs.

---

## 📞 Support

If you have questions:
1. Check **README.md** for API details
2. Check **API_EXAMPLES.md** for workflows
3. Check **CURL_COMMANDS.md** for examples
4. Try the `./test_api.sh` script

---

## 📜 File Summary

```
Source Code (5 files):
  ✅ main.go
  ✅ models/todo.go
  ✅ handlers/todo_handler.go
  ✅ routes/routes.go
  ✅ database/db.go
  ✅ config/config.go
  ✅ middleware/cors.go

Documentation (6 files):
  ✅ README.md
  ✅ QUICK_START.md
  ✅ CURL_COMMANDS.md
  ✅ API_EXAMPLES.md
  ✅ COLLECTIONS_GUIDE.md
  ✅ INDEX.md

Collections (2 files):
  ✅ todo_api_collection.json
  ✅ insomnia_collection.json

Scripts (2 files):
  ✅ test_api.sh
  ✅ .gitignore

Total: 17 files
```

---

## 🎉 You're All Set!

Everything is ready to use. Pick your preferred tool and start testing:
- **CLI**: Use cURL with CURL_COMMANDS.md
- **GUI (Postman)**: Import todo_api_collection.json
- **GUI (Insomnia)**: Import insomnia_collection.json

Happy coding! 🚀

