# Go Concepts Learned from School Management Project

A comprehensive guide to all Go language concepts, patterns, and best practices demonstrated in this project.

---

## Table of Contents

1. [Core Go Concepts](#core-go-concepts)
2. [Design Patterns](#design-patterns)
3. [Web Framework & HTTP](#web-framework--http)
4. [Database Patterns](#database-patterns)
5. [Authentication & Security](#authentication--security)
6. [Logging & Middleware](#logging--middleware)
7. [Configuration Management](#configuration-management)
8. [Data Structures & Types](#data-structures--types)
9. [Utility Functions](#utility-functions)
10. [Advanced Patterns](#advanced-patterns)
11. [Project Structure](#project-structure)
12. [Go Idioms & Best Practices](#go-idioms--best-practices)

---

## Core Go Concepts

### 1. Packages and Package Organization

**File:** `cmd/main.go`

```go
package main

func main() {
    // Program entry point
}
```

- `package main` indicates executable package
- `func main()` is the entry point
- Each directory = one package
- Package name must match directory name

**Key Concepts:**
- Packages provide namespace and encapsulation
- Exported identifiers: start with uppercase (public)
- Unexported identifiers: start with lowercase (private)

**File:** `config/config.go`

```go
func LoadConfig() (*AppConfig, error) {
    // Package-level function accessible everywhere
}
```

**File:** `internal/database/db.go`

```go
type Database struct {
    conn *sql.DB  // Unexported field (private to this package)
}

func (d *Database) GetConnection() *sql.DB {
    return d.conn  // Controlled access through public method
}
```

**Learning:**
- Private fields force controlled access through methods
- Encapsulation = data integrity and flexibility

---

### 2. Interfaces

**What is an Interface?**
A type that specifies a contract of methods. Any type implementing all methods satisfies the interface.

**File:** `internal/middleware/auth.go`

```go
// Custom type definition
type ContextKey string

// Handler implements http.Handler interface implicitly
// No explicit "implements" keyword in Go
func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    // Must implement: ServeHTTP(ResponseWriter, *Request)
}
```

**File:** `internal/utils/jwt.go`

```go
// Type assertion - checking if something implements an interface
if signingMethod, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
    return nil, fmt.Errorf("unexpected signing method")
}
```

**Key Concepts:**
- **Implicit Interface Implementation**: No "implements" keyword
- **Type Assertion**: `value.(Type)` syntax checks if value is of Type
- **OK Idiom**: `value, ok := interface{}.(Type)` safely checks types

---

### 3. Error Handling

**File:** `internal/database/db.go`

```go
// Multiple return values - last is usually error
func New(dsn string) (*Database, error) {
    conn, err := sql.Open("mysql", dsn)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }
    return &Database{conn: conn}, nil
}
```

**File:** `internal/repository/user_repo.go`

```go
// Checking specific errors
if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("user not found")
}

// Error wrapping with %w
return nil, fmt.Errorf("failed to fetch user: %w", err)
```

**Key Concepts:**
- **Error as Value**: errors are regular values, not exceptions
- **Multiple Return Values**: last value typically is error
- **Error Wrapping**: `%w` format verb preserves error chain
- **errors.Is()**: checks if error matches a specific type
- **defer**: cleanup even if error occurs

---

### 4. Structs and Type Definitions

**File:** `config/config.go`

```go
// Struct definition
type Database struct {
    Host     string      // Exported field (public)
    Port     string      // Accessible outside package
    User     string
    Password string
    Name     string
}

// Receiver method (pointer receiver - can modify struct)
func (d *Database) DSN() string {
    return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4",
        d.User, d.Password, d.Host, d.Port, d.Name)
}
```

**File:** `internal/models/school.go`

```go
// Complex struct with JSON tags
type Student struct {
    ID            int       `json:"id"`
    FirstName     string    `json:"first_name"`
    Email         string    `json:"email"`
    DateOfBirth   time.Time `json:"date_of_birth"`
    CreatedAt     time.Time `json:"created_at"`
}

// JSON tags control serialization/deserialization
// "id" = field name in JSON
// "-" = exclude field from JSON (e.g., password)
// "omitempty" = exclude if zero value
```

**Key Concepts:**
- **Struct**: Composite type grouping related data
- **JSON Tags**: Control JSON encoding/decoding
- **Exported Fields**: Capitalized (visible outside package)
- **Embedded Types**: `jwt.RegisteredClaims` in custom Claims

---

### 5. Methods and Receivers

**Pointer Receiver (Modifies Value):**

```go
// Pointer receiver - can modify the original struct
func (r *StudentRepository) Create(student *models.Student) error {
    // r points to StudentRepository
    // Modifications affect original
    result, err := r.db.Exec(query, ...)
    return err
}
```

**Value Receiver (Read-only):**

```go
// Value receiver - works with copy, doesn't modify original
func (d Database) DSN() string {
    // d is a copy of Database
    // Modifications don't affect original
    return fmt.Sprintf(...)
}
```

**Key Concepts:**
- **Receiver**: Method target (left of function name)
- **Pointer Receiver**: `(r *Type)` - modifies original, more efficient
- **Value Receiver**: `(r Type)` - works on copy, safer for small types
- **Method**: Function attached to a type

---

### 6. Goroutines and Concurrency

**Context-Based Timeout:**

```go
// Create context with 5-second timeout
ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
defer cancel()  // Always cleanup

// Use context in database operations
result, err := r.conn.ExecContext(ctx, query, args...)
```

**Key Concepts:**
- **Context**: Manages deadlines, cancellation, and values across goroutines
- **context.WithTimeout**: Creates context that cancels after duration
- **defer cancel()**: Guarantees cleanup, prevents resource leaks
- **ExecContext**: Database operation respecting context deadline

---

### 7. Time Handling

```go
// Parse duration from string
expiry, _ := time.ParseDuration("15m")    // 15 minutes
refresh, _ := time.ParseDuration("7d")    // Not standard, use arithmetic

// Time arithmetic
refreshExpiry := 7 * 24 * time.Hour

// Getting current time
now := time.Now()

// Time with timezone
loc, _ := time.LoadLocation("UTC")
timeWithTZ := time.Now().In(loc)

// Create time value (JWT claims)
jwt.NewNumericDate(time.Now().Add(expiry))
```

---

## Design Patterns

### 1. Dependency Injection

**File:** `internal/routes/routes.go`

```go
// Create repositories
userRepo := repository.NewUserRepository(conn)
studentRepo := repository.NewStudentRepository(conn)

// Inject into handlers (Constructor Injection)
authHandler := handler.NewAuthHandler(userRepo, cfg)
studentHandler := handler.NewStudentHandler(studentRepo)

// Handlers created with their dependencies
router.HandleFunc("/login", authHandler.Login).Methods("POST")
```

**File:** `internal/handler/auth_handler.go`

```go
// Handler holds dependencies
type AuthHandler struct {
    userRepo *repository.UserRepository
    cfg      *config.AppConfig
}

// Constructor function (Factory pattern)
func NewAuthHandler(userRepo *repository.UserRepository, cfg *config.AppConfig) *AuthHandler {
    return &AuthHandler{
        userRepo: userRepo,
        cfg:      cfg,
    }
}
```

**Key Concepts:**
- **Dependency Injection**: Pass dependencies to constructors
- **Loose Coupling**: Classes don't create their own dependencies
- **Testability**: Easy to mock dependencies in tests
- **Flexibility**: Easy to swap implementations

---

### 2. Repository Pattern

**File:** `internal/repository/student_repo.go`

```go
type StudentRepository struct {
    db *sql.DB
}

// CRUD Operations
func (r *StudentRepository) Create(student *models.Student) error {
    query := `INSERT INTO students (first_name, last_name, email, ...) VALUES (?, ?, ?, ...)`
    result, err := r.db.Exec(query, student.FirstName, student.LastName, ...)
    if err != nil {
        return err
    }
    id, _ := result.LastInsertId()
    student.ID = int(id)
    return nil
}

func (r *StudentRepository) GetByID(id int) (*models.Student, error) {
    query := `SELECT id, first_name, last_name, ... FROM students WHERE id = ?`
    student := &models.Student{}
    err := r.db.QueryRow(query, id).Scan(&student.ID, &student.FirstName, ...)
    return student, err
}

func (r *StudentRepository) List(limit, offset int) ([]*models.Student, error) {
    var students []*models.Student
    query := `SELECT ... FROM students LIMIT ? OFFSET ?`
    rows, err := r.db.Query(query, limit, offset)
    defer rows.Close()
    
    for rows.Next() {
        student := &models.Student{}
        rows.Scan(&student.ID, ...)
        students = append(students, student)
    }
    return students, rows.Err()
}

func (r *StudentRepository) Update(student *models.Student) error {
    // Update logic
}

func (r *StudentRepository) Delete(id int) error {
    // Delete logic
}
```

**Key Concepts:**
- **Repository**: Data access abstraction layer
- **Decouples Business Logic**: From database implementation
- **CRUD**: Create, Read, Update, Delete operations
- **Single Responsibility**: Each repo handles one entity type
- **Testability**: Easy to mock repository in handler tests

---

### 3. Handler/Controller Pattern

**File:** `internal/handler/exam_handler.go`

```go
// Handler type holds dependencies
type ExamHandler struct {
    examRepo *repository.ExamRepository
}

// Standard HTTP handler signature
func (h *ExamHandler) Create(w http.ResponseWriter, r *http.Request) {
    // 1. Parse request
    var exam models.Exam
    json.NewDecoder(r.Body).Decode(&exam)
    
    // 2. Validate
    if exam.Name == "" {
        utils.ErrorResponse(w, http.StatusBadRequest, "Invalid input", "Name required")
        return
    }
    
    // 3. Call repository
    id, err := h.examRepo.Create(&exam)
    if err != nil {
        utils.ErrorResponse(w, http.StatusInternalServerError, "Failed", err.Error())
        return
    }
    
    // 4. Return response
    exam.ID = int(id)
    utils.SuccessResponse(w, http.StatusCreated, "Exam created", exam)
}

func (h *ExamHandler) List(w http.ResponseWriter, r *http.Request) {
    // Parse query parameters
    limit, _ := strconv.Atoi(r.URL.Query().Get("limit"))
    if limit == 0 {
        limit = 10  // Default
    }
    
    // Get from repository
    exams, err := h.examRepo.List(limit, 0)
    
    // Return response
    utils.SuccessResponse(w, http.StatusOK, "Success", exams)
}
```

**Key Concepts:**
- **Handler**: HTTP request processor
- **Standard Signature**: `func(http.ResponseWriter, *http.Request)`
- **Separation**: HTTP concerns from business logic
- **Repository Call**: Handlers use repositories for data
- **Response Formatting**: Consistent response using utilities

---

### 4. Factory/Constructor Pattern

**File:** `internal/database/db.go`

```go
// Factory function returns configured instance
func New(dsn string) (*Database, error) {
    // Open connection
    conn, err := sql.Open("mysql", dsn)
    if err != nil {
        return nil, fmt.Errorf("failed to open database: %w", err)
    }
    
    // Configure connection pool
    conn.SetMaxOpenConns(25)
    conn.SetMaxIdleConns(5)
    
    // Test connection
    err = conn.Ping()
    if err != nil {
        return nil, fmt.Errorf("failed to ping database: %w", err)
    }
    
    // Return configured instance
    return &Database{conn: conn}, nil
}
```

**Key Concepts:**
- **Factory Function**: Creates and configures objects
- **Error in Constructor**: Return error if initialization fails
- **Consistent State**: Ensures object is ready to use
- **Convention**: Use `New` prefix for constructor functions

---

### 5. Middleware Pattern

**File:** `internal/middleware/auth.go`

```go
// Middleware is a higher-order function
func AuthMiddleware(cfg *config.AppConfig) func(http.Handler) http.Handler {
    // Returns a function
    return func(next http.Handler) http.Handler {
        // Returns http.HandlerFunc
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // 1. Extract token from header
            authHeader := r.Header.Get("Authorization")
            parts := strings.Split(authHeader, " ")
            
            if len(parts) != 2 || parts[0] != "Bearer" {
                utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "Invalid header")
                return  // Stop processing
            }
            
            // 2. Validate token
            token := parts[1]
            claims, err := utils.ValidateToken(token, cfg)
            if err != nil {
                utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", err.Error())
                return
            }
            
            // 3. Add to context for downstream handlers
            ctx := context.WithValue(r.Context(), UserContextKey, claims)
            
            // 4. Call next handler with modified context
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

**Usage:**

```go
// Apply to route group
protected := router.PathPrefix("/api/v1").Subrouter()
protected.Use(middleware.AuthMiddleware(cfg))  // Apply middleware

// All routes under protected will require authentication
protected.HandleFunc("/profile", authHandler.GetProfile).Methods("GET")
protected.HandleFunc("/students", studentHandler.List).Methods("GET")
```

**Key Concepts:**
- **Function Composition**: Middleware = function returning function
- **Chain of Responsibility**: Each middleware can stop chain or continue
- **Separation**: Cross-cutting concerns (auth, logging, CORS)
- **Reusability**: Apply same middleware to multiple routes
- **Order Matters**: Middleware executes in registration order

---

### 6. Context Value Pattern

```go
// Define custom context key (type-safe)
type ContextKey string
const UserContextKey ContextKey = "user"

// Add value to context
claims := &utils.Claims{UserID: 1, Email: "user@example.com"}
ctx := context.WithValue(r.Context(), UserContextKey, claims)

// Create new request with context
newRequest := r.WithContext(ctx)

// Retrieve value in downstream code
claims, ok := r.Context().Value(UserContextKey).(*utils.Claims)
if !ok {
    return nil  // Type assertion failed
}
```

**Key Concepts:**
- **Type Safety**: Use typed constants for keys
- **Immutability**: Context is immutable (create new with values)
- **Propagation**: Context passed down through call chain
- **Type Assertion**: Safely retrieve typed values

---

### 7. Configuration Pattern

**File:** `config/config.go`

```go
type AppConfig struct {
    Database Database
    Server   Server
    JWT      JWT
    Email    Email
    AppEnv   string
    LogLevel string
}

type Database struct {
    Host     string
    Port     string
    User     string
    Password string
    Name     string
}

type JWT struct {
    Secret string
    Expiry time.Duration
    RefreshExpiry time.Duration
}

// Load configuration from environment
func LoadConfig() (*AppConfig, error) {
    godotenv.Load()  // Load from .env file
    
    return &AppConfig{
        Database: Database{
            Host:     getEnv("DB_HOST", "localhost"),
            Port:     getEnv("DB_PORT", "3306"),
            User:     getEnv("DB_USER", "root"),
            Password: getEnv("DB_PASSWORD", ""),
            Name:     getEnv("DB_NAME", "school"),
        },
        Server: Server{
            Host: getEnv("SERVER_HOST", "0.0.0.0"),
            Port: getEnv("SERVER_PORT", "8080"),
        },
        JWT: JWT{
            Secret: getEnv("JWT_SECRET", "default-secret"),
            Expiry: parseDuration(getEnv("JWT_EXPIRY", "15m")),
        },
        AppEnv: getEnv("APP_ENV", "development"),
    }, nil
}

// Safe environment variable reading with default
func getEnv(key, defaultVal string) string {
    if value, exists := os.LookupEnv(key); exists {
        return value
    }
    return defaultVal
}
```

**Key Concepts:**
- **Nested Structs**: Group related configuration
- **Environment Variables**: 12-factor app principle
- **Defaults**: Fallback values if env var not set
- **Type Safety**: Configuration as strongly-typed struct
- **Single Responsibility**: Config package only loads config

---

## Web Framework & HTTP

### 1. Gorilla Mux Routing

**File:** `internal/routes/routes.go`

```go
// Create router
router := mux.NewRouter()

// Apply global middleware
router.Use(middleware.LoggerMiddleware)
router.Use(middleware.CORSMiddleware)

// Auth routes (no authentication needed)
auth := router.PathPrefix("/api/v1/auth").Subrouter()
{
    auth.HandleFunc("/register", authHandler.Register).Methods("POST")
    auth.HandleFunc("/login", authHandler.Login).Methods("POST")
}

// Protected routes (require authentication)
protected := router.PathPrefix("/api/v1").Subrouter()
protected.Use(middleware.AuthMiddleware(cfg))
{
    // Student routes with path variables
    protected.HandleFunc("/students", studentHandler.List).Methods("GET")
    protected.HandleFunc("/students", studentHandler.Create).Methods("POST")
    protected.HandleFunc("/students/{id}", studentHandler.GetByID).Methods("GET")
    protected.HandleFunc("/students/{id}", studentHandler.Update).Methods("PUT")
    protected.HandleFunc("/students/{id}", studentHandler.Delete).Methods("DELETE")
    
    // Nested paths
    protected.HandleFunc("/classes/{class_id}/students", studentHandler.GetByClassID).Methods("GET")
    protected.HandleFunc("/students/{student_id}/fees", feesHandler.GetStudentFees).Methods("GET")
}

// Health check (always accessible)
router.HandleFunc("/api/v1/health", healthHandler).Methods("GET")
```

**Starting Server:**

```go
// cmd/main.go
addr := cfg.Server.Host + ":" + cfg.Server.Port
log.Printf("🚀 Server starting on %s", addr)

if err := http.ListenAndServe(addr, router); err != nil {
    log.Fatalf("Server failed: %v", err)
}
```

**Key Concepts:**
- **Router Creation**: `mux.NewRouter()` creates new router
- **Path Prefix**: `PathPrefix()` creates subrouter for grouped routes
- **HTTP Methods**: `.Methods("GET", "POST", ...)` specifies allowed methods
- **Path Variables**: `{id}` in path are dynamic
- **Middleware Application**: `subrouter.Use(middleware)` applies to group
- **HTTP Listen**: `http.ListenAndServe(addr, handler)` starts server

---

### 2. HTTP Handler Functions

```go
// Standard HTTP handler signature
func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
    // w: http.ResponseWriter - write response
    // r: *http.Request - incoming request
}
```

**Complete Handler Example:**

```go
func (h *StudentHandler) Create(w http.ResponseWriter, r *http.Request) {
    // 1. Parse request body
    var req models.Student
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", err.Error())
        return
    }
    defer r.Body.Close()
    
    // 2. Validate input
    if req.FirstName == "" || req.Email == "" {
        utils.ErrorResponse(w, http.StatusBadRequest, "Missing fields", "First name and email required")
        return
    }
    
    // 3. Business logic (call repository)
    student := &models.Student{
        FirstName:     req.FirstName,
        LastName:      req.LastName,
        Email:         req.Email,
        EnrollmentDate: time.Now(),
    }
    
    if err := h.studentRepo.Create(student); err != nil {
        utils.ErrorResponse(w, http.StatusInternalServerError, "Database error", err.Error())
        return
    }
    
    // 4. Return success response
    utils.SuccessResponse(w, http.StatusCreated, "Student created successfully", student)
}
```

**Key Concepts:**
- **Request Parsing**: `json.NewDecoder(r.Body).Decode()` reads JSON body
- **Response Writing**: `w.WriteHeader()`, `json.NewEncoder(w).Encode()` write response
- **Status Codes**: 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Internal Server Error
- **Error Early Return**: Stop processing on validation/error
- **Defer Close**: Ensure body is closed

---

### 3. Path Variables

```go
// Route definition with path variable
router.HandleFunc("/students/{id}", handler.GetByID).Methods("GET")

// Extracting in handler
func (h *StudentHandler) GetByID(w http.ResponseWriter, r *http.Request) {
    // Extract from URL path
    vars := mux.Vars(r)
    idStr := vars["id"]  // Get "id" from {id}
    
    // Convert string to int
    id, err := strconv.Atoi(idStr)
    if err != nil {
        utils.ErrorResponse(w, http.StatusBadRequest, "Invalid ID", "ID must be a number")
        return
    }
    
    // Use id to fetch student
    student, err := h.studentRepo.GetByID(id)
    if err != nil {
        utils.ErrorResponse(w, http.StatusNotFound, "Not found", "Student not found")
        return
    }
    
    utils.SuccessResponse(w, http.StatusOK, "Success", student)
}
```

**Key Concepts:**
- **Path Variables**: `{name}` in route pattern
- **Extraction**: `mux.Vars(r)` gets all variables
- **Type Conversion**: `strconv.Atoi()` string to int
- **Error Handling**: Validate type conversion result

---

### 4. Query Parameters

```go
// Route with query parameters
// Example: GET /students?limit=10&offset=20&sort=name

func (h *StudentHandler) List(w http.ResponseWriter, r *http.Request) {
    // Extract query parameters
    limitStr := r.URL.Query().Get("limit")
    offsetStr := r.URL.Query().Get("offset")
    sortStr := r.URL.Query().Get("sort")
    
    // Convert with defaults
    limit := 10
    if l, err := strconv.Atoi(limitStr); err == nil && l > 0 {
        limit = l
    }
    
    offset := 0
    if o, err := strconv.Atoi(offsetStr); err == nil && o >= 0 {
        offset = o
    }
    
    // Use parameters
    students, err := h.studentRepo.List(limit, offset)
    utils.SuccessResponse(w, http.StatusOK, "Success", students)
}
```

**Key Concepts:**
- **Query String**: Part of URL after `?`
- **Access**: `r.URL.Query().Get("key")` returns string value
- **Parsing**: Convert strings to proper types
- **Defaults**: Provide sensible defaults if parameter missing

---

### 5. CORS Middleware

**File:** `internal/middleware/cors.go`

```go
func CORSMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Set CORS headers
        w.Header().Set("Access-Control-Allow-Origin", "*")  // Any origin
        w.Header().Set("Access-Control-Allow-Credentials", "true")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, PATCH")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
        w.Header().Set("Access-Control-Max-Age", "86400")
        
        // Handle preflight requests
        if r.Method == http.MethodOptions {
            w.WriteHeader(http.StatusOK)
            return
        }
        
        next.ServeHTTP(w, r)
    })
}
```

**Key Concepts:**
- **CORS**: Cross-Origin Resource Sharing
- **Preflight**: Browser sends OPTIONS request before actual request
- **Headers**: Control which origins, methods, headers are allowed
- **OPTIONS Handling**: Return 200 OK immediately for preflight

---

### 6. JSON Encoding/Decoding

**Decoding Request Body:**

```go
var req models.LoginRequest
if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
    return nil, fmt.Errorf("invalid JSON: %w", err)
}
// req.Email and req.Password are now populated
```

**Encoding Response:**

```go
response := models.AuthResponse{
    AccessToken: token,
    User: user,
}
w.Header().Set("Content-Type", "application/json")
json.NewEncoder(w).Encode(response)
```

**JSON Tags:**

```go
type User struct {
    ID        int    `json:"id"`              // Field name in JSON
    Email     string `json:"email"`
    Password  string `json:"-"`               // Exclude from JSON
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at,omitempty"` // Omit if empty
}
```

**Key Concepts:**
- **json.Decoder**: Streaming decode from io.Reader
- **json.Encoder**: Streaming encode to io.Writer
- **JSON Tags**: Control serialization behavior
- **Omitempty**: Exclude zero values from JSON
- **Hyphen Tag**: `-` excludes field entirely

---

## Database Patterns

### 1. Connection Pooling

**File:** `internal/database/db.go`

```go
func New(dsn string) (*Database, error) {
    conn, err := sql.Open("mysql", dsn)
    if err != nil {
        return nil, err
    }
    
    // Configure connection pool
    conn.SetMaxOpenConns(25)   // Max concurrent open connections
    conn.SetMaxIdleConns(5)    // Max idle connections to keep
    conn.SetConnMaxLifetime(0) // Connection lifetime (0 = unlimited)
    
    return &Database{conn: conn}, nil
}
```

**Key Concepts:**
- **Connection Pool**: Reuse connections for performance
- **MaxOpenConns**: Prevent resource exhaustion
- **MaxIdleConns**: Keep some warm for reuse
- **Connection Lifetime**: Close and recreate old connections

---

### 2. Prepared Statements

```go
// Parameterized query prevents SQL injection
query := `INSERT INTO users (email, password, role, created_at) VALUES (?, ?, ?, ?)`

// Execute with parameters
result, err := r.db.Exec(query, 
    user.Email, 
    hashedPassword, 
    user.Role, 
    time.Now(),
)

if err != nil {
    return nil, fmt.Errorf("failed to create user: %w", err)
}

// Get auto-generated ID
id, err := result.LastInsertId()
user.ID = int(id)
```

**Key Concepts:**
- **? Placeholder**: Parameter positions (not specific like $1 in PostgreSQL)
- **Parameter Binding**: Values automatically escaped
- **SQL Injection Prevention**: Can't inject SQL through parameters
- **LastInsertId()**: Get auto-generated primary key

---

### 3. Query Methods

**Single Row Query:**

```go
// Get one row
student := &models.Student{}
query := `SELECT id, first_name, last_name, email, ... FROM students WHERE id = ?`
err := r.db.QueryRow(query, id).Scan(
    &student.ID,
    &student.FirstName,
    &student.LastName,
    &student.Email,
    // ... more fields
)

if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("student not found")
}
if err != nil {
    return nil, err
}
```

**Multiple Rows Query:**

```go
// Get many rows
var students []*models.Student
query := `SELECT id, first_name, email, ... FROM students LIMIT ? OFFSET ?`
rows, err := r.db.Query(query, limit, offset)
if err != nil {
    return nil, err
}
defer rows.Close()  // Always close rows!

for rows.Next() {
    student := &models.Student{}
    err := rows.Scan(&student.ID, &student.FirstName, &student.Email, ...)
    if err != nil {
        return nil, err
    }
    students = append(students, student)
}

// Check for iteration errors
if err := rows.Err(); err != nil {
    return nil, err
}

return students, nil
```

**Key Concepts:**
- **QueryRow()**: Optimized for single result
- **Query()**: Returns *sql.Rows for multiple results
- **defer rows.Close()**: Always close to free resources
- **rows.Next()**: Iterate through results
- **rows.Err()**: Check for errors during iteration
- **Scan()**: Copy row values into variables

---

### 4. Context in Database Operations

```go
// Create context with timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

// Use context-aware query
var name string
err := r.db.QueryRowContext(ctx, 
    "SELECT name FROM classes WHERE id = ?", 
    classID,
).Scan(&name)

// If query exceeds 5 seconds, context cancels it
if err == context.DeadlineExceeded {
    return nil, fmt.Errorf("query timeout")
}
```

**Context-Aware Methods:**
- `QueryContext(ctx, query, args)` - query returning multiple rows
- `QueryRowContext(ctx, query, args)` - query returning single row
- `ExecContext(ctx, query, args)` - execute insert/update/delete
- `PrepareContext(ctx, query)` - prepare statement

**Key Concepts:**
- **Timeout**: Cancel operations if they take too long
- **Cancellation**: Stop operations cleanly
- **Resource Cleanup**: Defer cancel() ensures cleanup
- **Database Responsiveness**: Prevent hanging requests

---

### 5. Nullable SQL Fields

```go
// Database can have NULL values
// Go types can't be nil (except pointers), so use sql.Null* types

type StudentPerformance struct {
    AverageMarks sql.NullFloat64  // Can be NULL in database
    HighestScore sql.NullFloat64
}

func (r *StudentRepository) GetPerformance(id int) (map[string]interface{}, error) {
    var avgMarks sql.NullFloat64
    
    err := r.db.QueryRow(
        "SELECT AVG(marks) FROM exam_results WHERE student_id = ?", 
        id,
    ).Scan(&avgMarks)
    
    if err != nil {
        return nil, err
    }
    
    // Check if value is NULL
    result := make(map[string]interface{})
    if avgMarks.Valid {
        result["average_marks"] = avgMarks.Float64
    } else {
        result["average_marks"] = nil  // Or 0, depending on requirement
    }
    
    return result, nil
}
```

**Nullable Types:**
- `sql.NullBool` - for BOOLEAN
- `sql.NullString` - for VARCHAR
- `sql.NullInt64` - for INTEGER
- `sql.NullFloat64` - for DECIMAL/FLOAT
- `sql.NullTime` - for DATETIME/DATE

**Key Concepts:**
- **NullXxx.Valid**: boolean indicating if value is NULL
- **NullXxx.Value**: actual value if Valid is true
- **Always Check Valid**: Prevent zero value confusion

---

### 6. Dynamic Query Construction

```go
func (r *FeesRepository) List(status string, limit, offset int) ([]*models.Fee, error) {
    // Start with base query
    query := `SELECT id, student_id, amount, status, created_at FROM fees`
    var args []interface{}
    
    // Add WHERE clause conditionally
    if status != "" {
        query += ` WHERE status = ?`
        args = append(args, status)
    }
    
    // Add sorting
    query += ` ORDER BY created_at DESC`
    
    // Add pagination
    query += ` LIMIT ? OFFSET ?`
    args = append(args, limit, offset)
    
    // Execute with variable arguments
    rows, err := r.db.Query(query, args...)
    // ... process rows
}
```

**Key Concepts:**
- **String Concatenation**: Build query dynamically
- **Interface{} Slice**: Store arguments of any type
- **Variadic Arguments**: Unpack slice as arguments with `...`
- **Safe**: Still uses ? placeholders, no SQL injection

---

### 7. Aggregate Functions

```go
// Get attendance statistics
func (r *AttendanceRepository) GetSummary(studentID int) (map[string]interface{}, error) {
    query := `
        SELECT
            COUNT(*) as total_days,
            SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) as present_days,
            ROUND(
                (SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) * 100.0) / 
                COUNT(*), 2
            ) as attendance_percentage
        FROM attendance
        WHERE student_id = ?
    `
    
    var totalDays, presentDays, percentage sql.NullInt64
    err := r.db.QueryRow(query, studentID).Scan(&totalDays, &presentDays, &percentage)
    
    result := make(map[string]interface{})
    if totalDays.Valid {
        result["total_days"] = totalDays.Int64
    }
    if presentDays.Valid {
        result["present_days"] = presentDays.Int64
    }
    if percentage.Valid {
        result["percentage"] = float64(percentage.Int64) / 100
    }
    
    return result, nil
}
```

**SQL Aggregate Functions:**
- `COUNT(*)` - count rows
- `SUM()` - sum values
- `AVG()` - average
- `MIN()` / `MAX()` - minimum/maximum
- `GROUP_CONCAT()` - concatenate strings
- `CASE WHEN ... END` - conditional logic

**Key Concepts:**
- **Aggregation**: Process multiple rows into single result
- **CASE Statement**: SQL conditional logic
- **NULL Handling**: Use sql.Null* types
- **Math Operations**: Percentage calculations etc.

---

## Authentication & Security

### 1. JWT Implementation

**File:** `internal/utils/jwt.go`

```go
// Define claims (payload)
type Claims struct {
    UserID int    `json:"user_id"`
    Email  string `json:"email"`
    Role   string `json:"role"`
    jwt.RegisteredClaims  // Built-in claims: ExpiresAt, IssuedAt, etc.
}

// Generate token
func GenerateAccessToken(userID int, email, role string, cfg *config.AppConfig) (string, error) {
    // Create claims with expiration
    claims := &Claims{
        UserID: userID,
        Email:  email,
        Role:   role,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(cfg.JWT.Expiry)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
            Issuer:    "school-management",
        },
    }
    
    // Create token with claims
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    
    // Sign with secret key
    return token.SignedString([]byte(cfg.JWT.Secret))
}

// Validate and parse token
func ValidateToken(tokenString string, cfg *config.AppConfig) (*Claims, error) {
    claims := &Claims{}
    
    // Parse token with validation
    token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
        // Verify signing method
        if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
            return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
        }
        return []byte(cfg.JWT.Secret), nil
    })
    
    if err != nil || !token.Valid {
        return nil, fmt.Errorf("invalid token: %w", err)
    }
    
    return claims, nil
}
```

**Token Structure:**
```
Header.Payload.Signature

Header: {
  "alg": "HS256",
  "typ": "JWT"
}

Payload (Claims):
{
  "user_id": 1,
  "email": "user@example.com",
  "role": "admin",
  "exp": 1234567890,  // Expiration timestamp
  "iat": 1234567800   // Issued at timestamp
}

Signature: HMAC256(Header + Payload, SecretKey)
```

**Key Concepts:**
- **JWT Structure**: Header.Payload.Signature
- **Claims**: Payload containing user info
- **Signing**: Secret key ensures token authenticity
- **Expiration**: Token valid only until exp time
- **Stateless**: No need to store tokens server-side

---

### 2. Password Hashing

**File:** `internal/utils/password.go`

```go
import "golang.org/x/crypto/bcrypt"

// Hash password using bcrypt
func HashPassword(password string) (string, error) {
    // GenerateFromPassword returns hashed password
    // bcrypt.DefaultCost ≈ 10 (iterations, higher = slower but more secure)
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
    if err != nil {
        return "", err
    }
    return string(bytes), nil
}

// Compare password with hash
func CheckPasswordHash(password, hash string) bool {
    // Returns nil if password matches hash
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}
```

**Usage:**

```go
// When registering
hashedPassword, err := utils.HashPassword(req.Password)
if err != nil {
    return nil, err
}
user.Password = hashedPassword  // Store hash, not plaintext

// When logging in
isValid := utils.CheckPasswordHash(req.Password, user.Password)
if !isValid {
    return nil, errors.New("invalid password")
}
```

**Key Concepts:**
- **Bcrypt**: One-way hashing algorithm
- **Salting**: Bcrypt includes salt automatically
- **Cost Factor**: Higher = slower but more secure
- **Never Store Plaintext**: Store hash only
- **Always Compare Hashes**: Never expose passwords

---

### 3. Token Validation in Middleware

**File:** `internal/middleware/auth.go`

```go
func AuthMiddleware(cfg *config.AppConfig) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // 1. Get Authorization header
            authHeader := r.Header.Get("Authorization")
            if authHeader == "" {
                utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "Missing authorization header")
                return
            }
            
            // 2. Parse "Bearer <token>" format
            parts := strings.Split(authHeader, " ")
            if len(parts) != 2 || parts[0] != "Bearer" {
                utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "Invalid header format")
                return
            }
            
            // 3. Validate token
            token := parts[1]
            claims, err := utils.ValidateToken(token, cfg)
            if err != nil {
                utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", err.Error())
                return
            }
            
            // 4. Add claims to context for downstream handlers
            ctx := context.WithValue(r.Context(), middleware.UserContextKey, claims)
            
            // 5. Continue to next handler with context
            next.ServeHTTP(w, r.WithContext(ctx))
        })
    }
}
```

**Usage in Handler:**

```go
func (h *Handler) GetProfile(w http.ResponseWriter, r *http.Request) {
    // Retrieve claims from context (set by AuthMiddleware)
    claims, ok := r.Context().Value(middleware.UserContextKey).(*utils.Claims)
    if !ok {
        utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "No user context")
        return
    }
    
    // Now we know who the user is
    user, err := h.userRepo.GetByID(claims.UserID)
    if err != nil {
        utils.ErrorResponse(w, http.StatusNotFound, "Not found", "User not found")
        return
    }
    
    user.Password = ""  // Don't return password!
    utils.SuccessResponse(w, http.StatusOK, "Success", user)
}
```

**Key Concepts:**
- **Authorization Header**: "Bearer <token>" format
- **Token Extraction**: Split header and get token
- **Validation**: Check signature and expiration
- **Context Binding**: Pass user info to handlers
- **Type Assertion**: Safely retrieve typed values

---

## Logging & Middleware

### 1. Logger Middleware

**File:** `internal/middleware/logger.go`

```go
func LoggerMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Log request details
        startTime := time.Now()
        log.Printf("[%s] %s %s %s", 
            r.Method,        // GET, POST, etc.
            r.RequestURI,    // /api/v1/students?id=1
            r.RemoteAddr,    // Client IP
            r.UserAgent(),   // Browser/Client info
        )
        
        // Call next handler
        next.ServeHTTP(w, r)
        
        // Log response time
        duration := time.Since(startTime)
        log.Printf("Completed in %v", duration)
    })
}
```

**Key Concepts:**
- **Request Logging**: Method, URI, client IP
- **Timing**: Measure request duration
- **Middleware Wrapper**: Run code before and after handler
- **User Agent**: Identify client type (browser, mobile app, etc.)

---

### 2. CORS Middleware

**File:** `internal/middleware/cors.go`

```go
func CORSMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Set CORS headers
        w.Header().Set("Access-Control-Allow-Origin", "*")
        w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, PATCH")
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept")
        w.Header().Set("Access-Control-Max-Age", "86400")  // 24 hours
        w.Header().Set("Access-Control-Allow-Credentials", "true")
        
        // Respond to preflight OPTIONS requests
        if r.Method == http.MethodOptions {
            w.WriteHeader(http.StatusOK)
            return  // Stop processing
        }
        
        next.ServeHTTP(w, r)
    })
}
```

**How CORS Works:**

1. Browser sends preflight (OPTIONS) request
2. Server responds with CORS headers
3. Browser checks if origin is allowed
4. Browser sends actual request (GET/POST/etc.)
5. Server responds normally

**Key Concepts:**
- **Access-Control-Allow-Origin**: Which origins can access
- **Access-Control-Allow-Methods**: Which HTTP methods allowed
- **Access-Control-Allow-Headers**: Which request headers allowed
- **Preflight**: OPTIONS request before actual request

---

### 3. Middleware Chaining

```go
// In main.go
router := mux.NewRouter()

// Apply global middleware in order
router.Use(middleware.LoggerMiddleware)     // Logs all requests
router.Use(middleware.CORSMiddleware)       // Sets CORS headers

// Route groups with conditional middleware
protected := router.PathPrefix("/api/v1").Subrouter()
protected.Use(middleware.AuthMiddleware(cfg))  // Only on protected routes

// Middleware execution order (for incoming request):
// 1. LoggerMiddleware
// 2. CORSMiddleware
// 3. AuthMiddleware (only if route is under protected)
// 4. Handler function
// 5. Reverse for response
```

**Middleware Chain Pattern:**

```
Request Flow:
Logger Middleware (before)
  ↓
CORS Middleware (before)
  ↓
Auth Middleware (before)  [if protected route]
  ↓
Handler Function
  ↓
Auth Middleware (after)   [if protected route]
  ↓
CORS Middleware (after)
  ↓
Logger Middleware (after)
```

---

## Configuration Management

### 1. Environment Variable Loading

**File:** `config/config.go`

```go
import "github.com/joho/godotenv"

func LoadConfig() (*AppConfig, error) {
    // Load .env file (values override with env vars)
    godotenv.Load()  // Looks for .env in current directory
    
    // Read configuration from environment
    return &AppConfig{
        Database: Database{
            Host:     getEnv("DB_HOST", "localhost"),
            Port:     getEnv("DB_PORT", "3306"),
            User:     getEnv("DB_USER", "root"),
            Password: getEnv("DB_PASSWORD", ""),
            Name:     getEnv("DB_NAME", "school"),
        },
        Server: Server{
            Host: getEnv("SERVER_HOST", "0.0.0.0"),
            Port: getEnv("SERVER_PORT", "8080"),
        },
    }, nil
}

// Safe environment variable reading
func getEnv(key, defaultVal string) string {
    value, exists := os.LookupEnv(key)
    if !exists {
        return defaultVal
    }
    return value
}
```

**.env File:**

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=school_management

SERVER_PORT=8080
SERVER_HOST=0.0.0.0

JWT_SECRET=your_super_secret_jwt_key
JWT_EXPIRY=15m
```

**Key Concepts:**
- **12-Factor App**: Configuration via environment variables
- **godotenv**: Load from .env file for development
- **Environment Variables**: Set on server for production
- **Defaults**: Fallback values for development

---

### 2. Configuration Hierarchy

```
Production: Environment variables (highest priority)
    ↓
.env file (development)
    ↓
Default values in code (lowest priority)
```

**Example:**

```bash
# Production - use actual values
export DB_USER=prod_user
export DB_PASSWORD=secure_password
export DB_HOST=db.production.com

# Development - .env file with defaults
# DB_USER=root
# DB_PASSWORD=
# DB_HOST=localhost
```

---

## Data Structures & Types

### 1. Model Structs

**File:** `internal/models/school.go`

```go
type Student struct {
    ID             int       `json:"id"`
    FirstName      string    `json:"first_name"`
    LastName       string    `json:"last_name"`
    Email          string    `json:"email"`
    Phone          string    `json:"phone"`
    DateOfBirth    time.Time `json:"date_of_birth"`
    ClassID        int       `json:"class_id"`
    EnrollmentDate time.Time `json:"enrollment_date"`
    CreatedAt      time.Time `json:"created_at"`
    UpdatedAt      time.Time `json:"updated_at"`
}

type ExamResult struct {
    ID            int       `json:"id"`
    ExamID        int       `json:"exam_id"`
    StudentID     int       `json:"student_id"`
    MarksObtained float64   `json:"marks_obtained"`
    Grade         string    `json:"grade"`
    Status        string    `json:"status"`  // pass/fail
    CreatedAt     time.Time `json:"created_at"`
}
```

**Key Concepts:**
- **Struct Tags**: Control JSON serialization
- **Field Types**: Appropriate types for data
- **Timestamps**: Track creation/modification
- **Foreign Keys**: Reference to other entities

---

### 2. Request/Response DTOs

**File:** `internal/models/user.go`

```go
// Request from client
type LoginRequest struct {
    Email    string `json:"email" binding:"required,email"`
    Password string `json:"password" binding:"required,min=6"`
}

// Response to client
type AuthResponse struct {
    AccessToken  string `json:"access_token"`
    RefreshToken string `json:"refresh_token"`
    User         *User  `json:"user"`
    ExpiresIn    int    `json:"expires_in"`  // seconds
}

// User data (no password!)
type UserResponse struct {
    ID        int       `json:"id"`
    Email     string    `json:"email"`
    FirstName string    `json:"first_name"`
    LastName  string    `json:"last_name"`
    Role      string    `json:"role"`
    CreatedAt time.Time `json:"created_at"`
}
```

**Key Concepts:**
- **DTO Pattern**: Data Transfer Object
- **Request/Response Separation**: Different structures for different purposes
- **No Sensitive Data**: Password never in response
- **Pointer Fields**: Optional data

---

### 3. API Response Wrapper

**File:** `internal/utils/response.go`

```go
type APIResponse struct {
    StatusCode int           `json:"statusCode"`
    Success    bool          `json:"success"`
    Message    string        `json:"message"`
    Data       interface{}   `json:"data,omitempty"`
    Errors     []string      `json:"errors,omitempty"`
    FieldErrors map[string]string `json:"fieldErrors,omitempty"`
    Timestamp  float64       `json:"timestamp"`
    Path       string        `json:"path"`
}

// Success response
func SuccessResponse(w http.ResponseWriter, statusCode int, message string, data interface{}) {
    response := APIResponse{
        StatusCode: statusCode,
        Success:    true,
        Message:    message,
        Data:       data,
        Timestamp:  float64(time.Now().UnixNano()) / 1e9,
    }
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(statusCode)
    json.NewEncoder(w).Encode(response)
}

// Error response
func ErrorResponse(w http.ResponseWriter, statusCode int, message string, errors ...string) {
    response := APIResponse{
        StatusCode: statusCode,
        Success:    false,
        Message:    message,
        Errors:     errors,
        Timestamp:  float64(time.Now().UnixNano()) / 1e9,
    }
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(statusCode)
    json.NewEncoder(w).Encode(response)
}
```

**Usage:**

```go
// Success
utils.SuccessResponse(w, http.StatusCreated, "Student created", student)

// Errors
utils.ErrorResponse(w, http.StatusBadRequest, "Validation failed", "First name required", "Email invalid")
```

---

## Utility Functions

### 1. Response Utilities

```go
// Success with status 200
utils.SuccessResponse(w, http.StatusOK, "Retrieved successfully", data)

// Success with status 201 (Created)
utils.SuccessResponse(w, http.StatusCreated, "Created successfully", newItem)

// Error with status 400
utils.ErrorResponse(w, http.StatusBadRequest, "Invalid request", "Field X is required")

// Error with status 401
utils.ErrorResponse(w, http.StatusUnauthorized, "Not authorized", "Invalid credentials")

// Error with status 404
utils.ErrorResponse(w, http.StatusNotFound, "Not found", "Resource not found")

// Error with status 500
utils.ErrorResponse(w, http.StatusInternalServerError, "Server error", err.Error())
```

---

### 2. String Operations

```go
import "strings"

// Split string
parts := strings.Split("Bearer token123", " ")
// parts[0] = "Bearer", parts[1] = "token123"

// Contains
if strings.Contains(email, "@") { ... }

// ToLower/ToUpper
email := strings.ToLower(userInput)

// Trim
trimmed := strings.TrimSpace(input)

// Replace
result := strings.Replace(text, old, new, -1)  // -1 = replace all
```

---

### 3. Type Conversion

```go
import "strconv"

// String to Int
id, err := strconv.Atoi("123")  // Returns int and error
if err != nil {
    // Handle invalid number
}

// String to Int64
id64, err := strconv.ParseInt("123", 10, 64)  // Base 10, 64-bit
if err != nil {
    // Handle error
}

// Int to String
str := strconv.Itoa(123)  // Returns "123"

// String to Float
val, err := strconv.ParseFloat("3.14", 64)  // 64-bit float
```

---

## Advanced Patterns

### 1. Map as Generic Return Type

```go
func (r *StudentRepository) GetPerformance(studentID int) (map[string]interface{}, error) {
    // Create map
    result := make(map[string]interface{})
    
    // Query database
    var avgMarks, totalMarks sql.NullFloat64
    err := r.db.QueryRow(
        `SELECT AVG(marks), SUM(marks) FROM exam_results WHERE student_id = ?`,
        studentID,
    ).Scan(&avgMarks, &totalMarks)
    
    if err != nil {
        return nil, err
    }
    
    // Populate map
    if avgMarks.Valid {
        result["average_marks"] = avgMarks.Float64
    }
    if totalMarks.Valid {
        result["total_marks"] = totalMarks.Float64
    }
    
    result["student_id"] = studentID
    result["performance_grade"] = calculateGrade(avgMarks.Float64)
    
    return result, nil
}
```

**Key Concepts:**
- **map[string]interface{}**: Flexible, holds any value type
- **make(map[...])**: Create new map
- **Dynamic Keys**: Add any key at runtime
- **JSON Serialization**: Automatically converts to JSON object

---

### 2. Variadic Arguments

```go
// Function accepting variable number of arguments
func BuildQuery(baseQuery string, conditions ...interface{}) (string, []interface{}) {
    var args []interface{}
    query := baseQuery
    
    for i := 0; i < len(conditions); i += 2 {
        if i > 0 {
            query += " AND"
        }
        field := conditions[i].(string)
        value := conditions[i+1]
        
        query += fmt.Sprintf(" %s = ?", field)
        args = append(args, value)
    }
    
    return query, args
}

// Usage
query, args := BuildQuery(
    "SELECT * FROM students WHERE",
    "class_id", 1,
    "status", "active",
)
```

**Unpacking Slice:**

```go
args := []interface{}{1, "John", "active"}
rows, err := db.Query("SELECT * FROM students WHERE id=? AND name=? AND status=?", args...)
//                                                                                    ^^^^ Unpack slice
```

---

### 3. Nil Pointers and Pointer Operations

```go
// Create pointer
user := &models.User{}  // Allocate and get pointer

// Access fields through pointer
user.Email = "test@example.com"  // Go auto-dereferences
user.ID = 1

// Return pointer
func GetUser() *models.User {
    return &models.User{
        ID: 1,
        Email: "test@example.com",
    }
}

// Check for nil
var user *models.User
if user == nil {
    // User not initialized
}

// Dereference pointer
userValue := *user  // Get actual value (copy)

// Address of value
userPtr := &userValue  // Get pointer to value
```

---

### 4. Slice Operations

```go
// Initialize slice
var users []*models.User              // Nil slice
users := make([]*models.User, 0)     // Empty slice with capacity 0
users := make([]*models.User, 0, 10) // Empty slice with capacity 10

// Append
users = append(users, &user1)
users = append(users, &user2, &user3)  // Multiple items

// Loop
for i, user := range users {
    println(i, user.Email)
}

// Slice of slice
subset := users[0:5]  // Items 0 to 4
first := users[0]     // First item
last := users[len(users)-1]  // Last item

// Length and capacity
len(users)  // Number of elements
cap(users)  // Allocated capacity
```

---

### 5. Type Assertions

```go
// Type assertion
value := interface{}(42)
intVal, ok := value.(int)
if !ok {
    println("Not an int")
}

// Context value extraction
claims := r.Context().Value(UserContextKey)
userClaims, ok := claims.(*utils.Claims)
if !ok {
    // Wrong type or not found
    return nil
}

// Assert to specific interface
if handler, ok := someValue.(http.Handler); ok {
    // someValue implements http.Handler
}
```

---

### 6. Defer for Resource Cleanup

```go
// File operations
file, err := os.Open("data.txt")
if err != nil {
    return err
}
defer file.Close()  // Always close before returning

data, _ := ioutil.ReadAll(file)
return data

// Database rows
rows, _ := db.Query("SELECT * FROM users")
defer rows.Close()  // Prevents resource leak

for rows.Next() {
    // Process row
}

// Multiple defers (execute in reverse order)
func example() {
    defer println("3")
    defer println("2")
    defer println("1")
    println("0")
}
// Output: 0, 1, 2, 3
```

**Key Concepts:**
- **defer**: Executes just before function returns
- **LIFO**: Last deferred executes first
- **Guaranteed**: Runs even if panic occurs
- **Resource Cleanup**: Close files, rows, connections

---

### 7. Context Timeout Pattern

```go
// Create context with timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()  // Clean up

// Use in database operation
var user *models.User
err := db.QueryRowContext(ctx, 
    "SELECT * FROM users WHERE id = ?", 
    userID,
).Scan(&user.ID, &user.Email, ...)

// If query takes > 5 seconds
if err == context.DeadlineExceeded {
    return nil, fmt.Errorf("query timeout")
}

// Can also use context cancellation
go func() {
    time.Sleep(2 * time.Second)
    cancel()  // Cancel context after 2 seconds
}()

// Operation stops when context is cancelled
```

---

## Project Structure

**Directory Organization:**

```
school_management/
├── cmd/
│   └── main.go                          # Entry point
├── config/
│   └── config.go                        # Configuration loading
├── internal/
│   ├── database/
│   │   └── db.go                        # Database connection
│   ├── handler/                         # HTTP handlers
│   │   ├── auth_handler.go
│   │   ├── student_handler.go
│   │   ├── teacher_handler.go
│   │   ├── exam_handler.go
│   │   └── ... (more handlers)
│   ├── middleware/                      # Middleware
│   │   ├── auth.go
│   │   ├── cors.go
│   │   └── logger.go
│   ├── models/                          # Data models
│   │   ├── user.go
│   │   ├── school.go
│   │   └── ... (more models)
│   ├── repository/                      # Data access layer
│   │   ├── user_repo.go
│   │   ├── student_repo.go
│   │   ├── teacher_repo.go
│   │   └── ... (more repositories)
│   ├── routes/
│   │   └── routes.go                    # Route registration
│   └── utils/                           # Utilities
│       ├── jwt.go
│       ├── password.go
│       └── response.go
├── .env
├── .env.example
├── go.mod                               # Module definition
└── go.sum                               # Dependency checksums
```

**Layered Architecture:**

```
HTTP Request
    ↓
Routes (routes.go)
    ↓
Middleware (auth, cors, logger)
    ↓
Handler (Parse request, validate)
    ↓
Repository (Database operations)
    ↓
Database (MySQL)
    ↓
Repository (Return data)
    ↓
Handler (Format response)
    ↓
HTTP Response
```

---

## Go Idioms & Best Practices

### 1. Error Handling

```go
// ✅ GOOD: Always handle errors
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}

// ✅ GOOD: Specific error checking
if errors.Is(err, sql.ErrNoRows) {
    return nil, errors.New("not found")
}

// ✅ GOOD: Wrap errors to preserve context
return nil, fmt.Errorf("failed to fetch user: %w", err)

// ❌ BAD: Ignore errors
_ = someFunction()  // Only if deliberately ignoring

// ❌ BAD: Generic error handling
if err != nil {
    panic(err)  // Should return error instead
}
```

---

### 2. Interfaces

```go
// ✅ GOOD: Small, focused interfaces
type Reader interface {
    Read(p []byte) (n int, err error)
}

// ✅ GOOD: Implicit implementation (no "implements" keyword)
type File struct { ... }
func (f *File) Read(p []byte) (int, error) { ... }

// ❌ BAD: Large interfaces (hard to implement)
type Entity interface {
    Create() error
    Read() error
    Update() error
    Delete() error
    // ... many more methods
}
```

---

### 3. Blank Imports

```go
// Import driver for side effects (initialization)
import (
    _ "github.com/go-sql-driver/mysql"  // Register MySQL driver
)

// Driver registers itself on import
// Now sql.Open("mysql", dsn) works
```

---

### 4. Pointers vs Values

```go
// ✅ GOOD: Pointer receiver when method modifies
func (r *Repository) Create(item *Model) error {
    // r is modified (internal state changes)
    return r.db.Exec(...).Err
}

// ✅ GOOD: Value receiver for read-only
func (cfg Database) DSN() string {
    return fmt.Sprintf(...)  // No modification
}

// ✅ GOOD: Pointer for large structs (efficiency)
func ProcessLargeData(data *LargeStruct) error {
    // Pointer avoids copying large data
}

// ❌ BAD: Unnecessary pointers for small types
func (s string) Process() string {  // Should be value
    return strings.ToUpper(s)
}
```

---

### 5. Package-Level Functions

```go
// ✅ GOOD: Package-level utility functions
func LoadConfig() (*AppConfig, error) {
    // Accessible from any package as config.LoadConfig()
}

func getEnv(key, defaultVal string) string {
    // Private (lowercase) to package
}

// ✅ GOOD: Named return types (when improving readability)
func GetUser(id int) (user *User, err error) {
    user = &User{}
    err = db.QueryRow(...).Scan(...)
    return  // Implicit with named returns
}
```

---

### 6. Constants at Package Level

```go
// ✅ GOOD: Package-level constants
const (
    MaxPageSize     = 100
    DefaultPageSize = 10
    UserContextKey  = "user"
)

// ✅ GOOD: iota for enums
const (
    StatusPending = iota    // 0
    StatusActive  = iota    // 1
    StatusInactive = iota   // 2
)
```

---

### 7. Multiple Return Values

```go
// ✅ GOOD: Error as last return value
func GetUser(id int) (*User, error) {
    // ...
}

// ✅ GOOD: OK idiom
value, ok := someMap[key]
claims, ok := r.Context().Value(key).(*Claims)

if !ok {
    // Not found or wrong type
}

// ✅ GOOD: Check specific errors
if errors.Is(err, sql.ErrNoRows) {
    // Handle not found
}
```

---

### 8. Struct Tags

```go
// ✅ GOOD: Multiple tags
type User struct {
    Email    string `json:"email" binding:"required,email"`
    Password string `json:"-" binding:"required,min=6"`  // Exclude from JSON
    Name     string `json:"name,omitempty"`  // Omit if empty
}

// ✅ GOOD: Struct embedding
type Admin struct {
    User  // Embedded struct
    Role  string
}
admin := &Admin{User: User{...}, Role: "admin"}
```

---

### 9. Receiver Pattern

```go
// ✅ GOOD: Consistent receiver naming
func (h *Handler) ServeHTTP(...) {}
func (r *Repository) Create(...) {}
func (cfg *Config) Load() {}

// ✅ GOOD: Short receiver names (1-2 chars)
// ❌ BAD: Long receiver names (httpHandler, studentRepository)
```

---

### 10. Logging

```go
// ✅ GOOD: Use standard library log package
import "log"

log.Println("Info message")
log.Printf("Formatted: %v", value)

// ✅ GOOD: Log at different levels via third-party
// (Project uses basic log, but common pattern:)
// logger.Info("message")
// logger.Error("error occurred")
// logger.Debug("debug info")

// ❌ BAD: println for production logging
println("Debug info")  // Use log instead
```

---

## Summary of Key Takeaways

1. **Layered Architecture**: Handler → Repository → Database separation
2. **Dependency Injection**: Pass dependencies to constructors
3. **Error Handling**: Check errors, wrap with context
4. **Interfaces**: Use implicitly, keep small and focused
5. **Middleware**: Compose functionality through functions
6. **Security**: Hash passwords, validate tokens, use contexts
7. **Configuration**: 12-factor app with environment variables
8. **Gorilla Mux**: Simple routing with path variables and subrouters
9. **JWT**: Stateless authentication with claims
10. **Database**: Connection pooling, parameterized queries, proper resource cleanup

---

## Practice Exercises

1. **Add New Entity**: Add a new `subject_handler.go` and `subject_repo.go`
2. **Add Validation**: Implement input validation in handlers
3. **Add Logging**: Enhance logging with structured logging
4. **Add Tests**: Write unit tests for repositories and handlers
5. **Add Caching**: Implement Redis caching for frequently accessed data
6. **Error Handling**: Improve error messages and logging
7. **Rate Limiting**: Add rate limiting middleware
8. **Pagination**: Implement cursor-based pagination instead of offset/limit

---

**Last Updated:** 2026-06-17
**Project:** School Management System in Go
**Difficulty Level:** Intermediate to Advanced
