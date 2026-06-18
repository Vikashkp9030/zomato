# 🚀 1-Week Intensive Learning Plan - School Management Project

**Goal:** Master core Go concepts and build a working REST API with authentication

---

## 📋 Daily Breakdown

### **Day 1: Go Fundamentals & Project Setup** ⭐

**Morning (2-3 hours)**
- [ ] Understand Go project structure (cmd, internal, config)
- [ ] Learn packages and visibility (exported/unexported)
- [ ] Understand main.go entry point
- [ ] Study struct definitions and tags (JSON tags)

**Practical Task (1 hour)**
```go
// internal/models/school.go
// Create 3 model structs:
// 1. Student {id, firstName, lastName, email, dateOfBirth, classId}
// 2. User {id, email, password, role, createdAt}
// 3. Exam {id, name, date, totalMarks, subject}
```

**Afternoon (2-3 hours)**
- [ ] Learn methods and receivers (pointer vs value)
- [ ] Understand error handling pattern (if err != nil)
- [ ] Study interfaces (implicit implementation)
- [ ] Learn type assertions

**Practical Task (1 hour)**
```go
// Add methods to Student struct:
// 1. (s *Student) FullName() string
// 2. (s *Student) IsAdult() bool
// 3. (s *Student) Validate() error

// Create interface:
// type Repository interface {
//   Create(item interface{}) error
//   GetByID(id int) (interface{}, error)
// }
```

**Evening Review (30 mins)**
- Read GO_CONCEPTS_LEARNED.md sections: Core Go Concepts, Structs, Methods, Error Handling

---

### **Day 2: HTTP & Routing** 🌐

**Morning (2-3 hours)**
- [ ] Understand HTTP request/response cycle
- [ ] Learn Gorilla Mux router basics
- [ ] Study path variables and query parameters
- [ ] Learn JSON encoding/decoding

**Practical Task (1.5 hours)**
```go
// internal/routes/routes.go
// Setup basic routing:

func SetupRoutes() *mux.Router {
    router := mux.NewRouter()
    
    // Health check (no auth needed)
    router.HandleFunc("/api/v1/health", HealthHandler).Methods("GET")
    
    // Student routes
    router.HandleFunc("/api/v1/students", ListStudents).Methods("GET")
    router.HandleFunc("/api/v1/students", CreateStudent).Methods("POST")
    router.HandleFunc("/api/v1/students/{id}", GetStudent).Methods("GET")
    
    return router
}
```

**Afternoon (2-3 hours)**
- [ ] Learn response formatting patterns
- [ ] Study HTTP status codes
- [ ] Understand middleware concept
- [ ] Learn CORS basics

**Practical Task (1.5 hours)**
```go
// internal/utils/response.go
// Create response utility:

type APIResponse struct {
    Success    bool        `json:"success"`
    Message    string      `json:"message"`
    Data       interface{} `json:"data,omitempty"`
    Error      string      `json:"error,omitempty"`
    StatusCode int         `json:"statusCode"`
}

func SuccessResponse(w http.ResponseWriter, message string, data interface{}) { }
func ErrorResponse(w http.ResponseWriter, statusCode int, message string) { }
```

**Afternoon Practical (1 hour)**
```go
// internal/handler/student_handler.go
// Implement handlers:

func ListStudents(w http.ResponseWriter, r *http.Request) {
    // Parse query params: limit, offset
    // Return list of students
    utils.SuccessResponse(w, "Students retrieved", students)
}

func CreateStudent(w http.ResponseWriter, r *http.Request) {
    // Parse JSON body
    // Validate input
    // Return created student
}

func GetStudent(w http.ResponseWriter, r *http.Request) {
    // Extract {id} from path
    // Find student by ID
    // Return student or 404
}
```

**Evening Review (30 mins)**
- Read: HTTP Handler, Routing, JSON Encoding, Response Utilities sections

---

### **Day 3: Database & Repository Pattern** 💾

**Morning (2-3 hours)**
- [ ] Understand database connection setup
- [ ] Learn connection pooling concepts
- [ ] Study parameterized queries (prevent SQL injection)
- [ ] Learn QueryRow vs Query methods

**Practical Task (1.5 hours)**
```go
// internal/database/db.go
// Create database connection:

type Database struct {
    conn *sql.DB
}

func New(dsn string) (*Database, error) {
    // Open MySQL connection
    // Set MaxOpenConns(25), MaxIdleConns(5)
    // Test connection with Ping()
    // Return Database instance
}

func (d *Database) GetConnection() *sql.DB {
    return d.conn
}
```

**Afternoon (2-3 hours)**
- [ ] Learn Repository pattern
- [ ] Understand CRUD operations
- [ ] Study defer for resource cleanup
- [ ] Learn error handling in database operations

**Practical Task (2 hours)**
```go
// internal/repository/student_repo.go
// Implement StudentRepository:

type StudentRepository struct {
    db *sql.DB
}

func NewStudentRepository(db *sql.DB) *StudentRepository {
    return &StudentRepository{db: db}
}

// Implement methods:
func (r *StudentRepository) Create(student *models.Student) error { }
func (r *StudentRepository) GetByID(id int) (*models.Student, error) { }
func (r *StudentRepository) List(limit, offset int) ([]*models.Student, error) { }
func (r *StudentRepository) Update(student *models.Student) error { }
func (r *StudentRepository) Delete(id int) error { }
```

**Evening Review (30 mins)**
- Read: Database Patterns, Repository Pattern sections

---

### **Day 4: Authentication & Security** 🔐

**Morning (2-3 hours)**
- [ ] Learn password hashing with bcrypt
- [ ] Understand JWT tokens (structure: Header.Payload.Signature)
- [ ] Study token generation and validation
- [ ] Learn claims and expiration

**Practical Task (1.5 hours)**
```go
// internal/utils/password.go
// Password utilities:

func HashPassword(password string) (string, error) {
    // Use bcrypt.GenerateFromPassword
}

func CheckPasswordHash(password, hash string) bool {
    // Use bcrypt.CompareHashAndPassword
}

// internal/utils/jwt.go
// JWT utilities:

type Claims struct {
    UserID int    `json:"user_id"`
    Email  string `json:"email"`
    Role   string `json:"role"`
    jwt.RegisteredClaims
}

func GenerateAccessToken(userID int, email, role string, cfg *config.AppConfig) (string, error) { }
func ValidateToken(tokenString string, cfg *config.AppConfig) (*Claims, error) { }
```

**Afternoon (2-3 hours)**
- [ ] Learn middleware pattern
- [ ] Study authentication middleware
- [ ] Understand context value pattern
- [ ] Learn Authorization header parsing

**Practical Task (1.5 hours)**
```go
// internal/middleware/auth.go
// Auth middleware:

func AuthMiddleware(cfg *config.AppConfig) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // 1. Extract "Bearer <token>" from Authorization header
            // 2. Validate token
            // 3. Add claims to context
            // 4. Call next handler
        })
    }
}

// internal/handler/auth_handler.go
// Auth handlers:

func Register(w http.ResponseWriter, r *http.Request) {
    // Parse request: {email, password}
    // Validate input
    // Hash password
    // Create user in DB
    // Return success
}

func Login(w http.ResponseWriter, r *http.Request) {
    // Parse request: {email, password}
    // Find user by email
    // Compare password hash
    // Generate JWT token
    // Return token
}
```

**Evening Review (30 mins)**
- Read: Authentication & Security, Middleware Pattern sections

---

### **Day 5: Middleware & Configuration** ⚙️

**Morning (2-3 hours)**
- [ ] Learn CORS middleware
- [ ] Understand logger middleware
- [ ] Study middleware chaining
- [ ] Learn configuration management

**Practical Task (1.5 hours)**
```go
// internal/middleware/cors.go
// CORS middleware:

func CORSMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
        
        if r.Method == http.MethodOptions {
            w.WriteHeader(http.StatusOK)
            return
        }
        
        next.ServeHTTP(w, r)
    })
}

// internal/middleware/logger.go
// Logger middleware:

func LoggerMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        startTime := time.Now()
        log.Printf("[%s] %s %s", r.Method, r.RequestURI, r.RemoteAddr)
        
        next.ServeHTTP(w, r)
        
        duration := time.Since(startTime)
        log.Printf("Completed in %v", duration)
    })
}
```

**Afternoon (2-3 hours)**
- [ ] Learn environment variable loading
- [ ] Study configuration hierarchy
- [ ] Understand .env files
- [ ] Learn godotenv package

**Practical Task (1.5 hours)**
```go
// config/config.go
// Configuration management:

type AppConfig struct {
    Database Database
    Server   Server
    JWT      JWT
    AppEnv   string
}

type Database struct {
    Host     string
    Port     string
    User     string
    Password string
    Name     string
}

func LoadConfig() (*AppConfig, error) {
    godotenv.Load()  // Load from .env
    
    return &AppConfig{
        Database: Database{
            Host:     getEnv("DB_HOST", "localhost"),
            Port:     getEnv("DB_PORT", "3306"),
            User:     getEnv("DB_USER", "root"),
            Password: getEnv("DB_PASSWORD", ""),
            Name:     getEnv("DB_NAME", "school"),
        },
        // ... more config
    }, nil
}

func getEnv(key, defaultVal string) string {
    if value, exists := os.LookupEnv(key); exists {
        return value
    }
    return defaultVal
}
```

**Evening Review (30 mins)**
- Read: Middleware, Configuration Management sections

---

### **Day 6: Integration & Testing** 🔧

**Morning (2-3 hours)**
- [ ] Connect all pieces in main.go
- [ ] Set up routes with all middleware
- [ ] Create database initialization
- [ ] Test API with curl commands

**Practical Task (2 hours)**
```go
// cmd/main.go
// Complete main function:

func main() {
    // 1. Load configuration
    cfg, err := config.LoadConfig()
    if err != nil {
        log.Fatal(err)
    }
    
    // 2. Connect to database
    db, err := database.New(cfg.Database.DSN())
    if err != nil {
        log.Fatal(err)
    }
    defer db.GetConnection().Close()
    
    // 3. Create repositories
    studentRepo := repository.NewStudentRepository(db.GetConnection())
    userRepo := repository.NewUserRepository(db.GetConnection())
    
    // 4. Create handlers
    studentHandler := handler.NewStudentHandler(studentRepo)
    authHandler := handler.NewAuthHandler(userRepo, cfg)
    
    // 5. Setup routes
    router := mux.NewRouter()
    router.Use(middleware.LoggerMiddleware)
    router.Use(middleware.CORSMiddleware)
    
    // Public routes
    auth := router.PathPrefix("/api/v1/auth").Subrouter()
    auth.HandleFunc("/register", authHandler.Register).Methods("POST")
    auth.HandleFunc("/login", authHandler.Login).Methods("POST")
    
    // Protected routes
    protected := router.PathPrefix("/api/v1").Subrouter()
    protected.Use(middleware.AuthMiddleware(cfg))
    protected.HandleFunc("/students", studentHandler.List).Methods("GET")
    protected.HandleFunc("/students", studentHandler.Create).Methods("POST")
    protected.HandleFunc("/students/{id}", studentHandler.GetByID).Methods("GET")
    protected.HandleFunc("/students/{id}", studentHandler.Update).Methods("PUT")
    protected.HandleFunc("/students/{id}", studentHandler.Delete).Methods("DELETE")
    
    // 6. Start server
    addr := cfg.Server.Host + ":" + cfg.Server.Port
    log.Printf("🚀 Server starting on %s", addr)
    
    if err := http.ListenAndServe(addr, router); err != nil {
        log.Fatal(err)
    }
}
```

**Afternoon (2-3 hours)**
- [ ] Test registration endpoint
- [ ] Test login endpoint
- [ ] Test protected endpoints with token
- [ ] Test error handling
- [ ] Verify middleware order

**Testing Commands:**
```bash
# 1. Register
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"student@test.com","password":"password123"}'

# 2. Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"student@test.com","password":"password123"}'

# 3. Get students (use token from login response)
curl -X GET http://localhost:8080/api/v1/students \
  -H "Authorization: Bearer <token_from_login>"

# 4. Create student
curl -X POST http://localhost:8080/api/v1/students \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"firstName":"John","lastName":"Doe","email":"john@test.com","dateOfBirth":"2005-01-01"}'
```

**Evening Review (1 hour)**
- Document what you've built
- Fix any issues encountered
- Verify all endpoints work

---

### **Day 7: Polish & Advanced Topics** ✨

**Morning (2-3 hours)**
- [ ] Add input validation to handlers
- [ ] Improve error messages
- [ ] Add more endpoints (teacher, exam, attendance, fees)
- [ ] Create comprehensive API documentation

**Practical Task (1.5 hours)**
```go
// Add validation helpers
// internal/utils/validation.go

func ValidateEmail(email string) error {
    if !strings.Contains(email, "@") {
        return errors.New("invalid email format")
    }
    return nil
}

func ValidatePassword(password string) error {
    if len(password) < 6 {
        return errors.New("password must be at least 6 characters")
    }
    return nil
}

// Use in handlers:
if err := utils.ValidateEmail(req.Email); err != nil {
    utils.ErrorResponse(w, http.StatusBadRequest, "Validation failed", err.Error())
    return
}
```

**Afternoon (2-3 hours)**
- [ ] Create additional handlers (Teachers, Exams, Attendance, Fees)
- [ ] Implement remaining CRUD operations
- [ ] Test all new endpoints
- [ ] Create API curl commands documentation

**Key Files to Complete:**
```
internal/handler/
  ├── teacher_handler.go    (CRUD for teachers)
  ├── exam_handler.go       (CRUD for exams)
  ├── exam_result_handler.go (exam results)
  ├── attendance_handler.go  (mark/track attendance)
  └── fees_handler.go       (manage student fees)

internal/repository/
  ├── teacher_repo.go
  ├── exam_repo.go
  ├── exam_result_repo.go
  ├── attendance_repo.go
  └── fees_repo.go
```

**Evening (1.5 hours)**
- [ ] Run complete API test suite
- [ ] Create final API documentation
- [ ] Review all code for best practices
- [ ] Document lessons learned

---

## 📊 Learning Checklist

### Week Overview
- [x] Day 1: Fundamentals (Packages, Structs, Methods, Errors, Interfaces)
- [x] Day 2: HTTP & Routing (Handlers, JSON, Responses)
- [x] Day 3: Database (Connection, Repository, CRUD)
- [x] Day 4: Authentication (Hashing, JWT, Middleware)
- [x] Day 5: Configuration & Middleware (CORS, Logger, Config)
- [x] Day 6: Integration (Full Stack Testing)
- [x] Day 7: Polish (Validation, Documentation)

### Core Concepts Covered
- [x] Package Organization
- [x] Structs & Types
- [x] Methods & Receivers
- [x] Error Handling
- [x] Interfaces
- [x] HTTP Handlers
- [x] Gorilla Mux Routing
- [x] JSON Encoding/Decoding
- [x] Repository Pattern
- [x] Dependency Injection
- [x] Password Hashing
- [x] JWT Authentication
- [x] Middleware
- [x] CORS
- [x] Configuration Management
- [x] Database Operations
- [x] Connection Pooling
- [x] SQL Queries

---

## 📝 Quick Reference Commands

**Setup .env file:**
```bash
cat > .env << EOF
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=school_management
SERVER_HOST=0.0.0.0
SERVER_PORT=8080
JWT_SECRET=your_super_secret_jwt_key
JWT_EXPIRY=15m
EOF
```

**Run the server:**
```bash
go run cmd/main.go
```

**Test endpoints:**
```bash
# Health check
curl http://localhost:8080/api/v1/health

# Register
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password123"}'

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password123"}'
```

---

## 🎯 Success Criteria

By end of Week 1, you should:
- ✅ Understand Go's package and module system
- ✅ Implement clean layered architecture (Handler → Repository → Database)
- ✅ Build REST API with CRUD operations
- ✅ Implement JWT authentication
- ✅ Write secure, reusable code
- ✅ Handle errors gracefully
- ✅ Work with MySQL database
- ✅ Understand middleware pattern
- ✅ Have working API with multiple endpoints

---

## 🚀 Next Steps (After Week 1)

1. Add unit tests for repositories and handlers
2. Implement input validation using tags
3. Add rate limiting middleware
4. Implement pagination (cursor-based)
5. Add refresh token functionality
6. Implement role-based access control (RBAC)
7. Add caching with Redis
8. Deploy to production
9. Write comprehensive API documentation
10. Add monitoring and logging

---

**Start Date:** Today
**End Date:** 7 days from now
**Time Commitment:** 25-30 hours total (3-4 hours per day)
**Result:** Full working REST API with authentication!

Good luck! 🎉
