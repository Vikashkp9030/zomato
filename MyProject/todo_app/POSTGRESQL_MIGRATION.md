# PostgreSQL Migration Guide

## Migration Status: ✅ COMPLETE

The TODO API has been successfully migrated from **SQLite** to **PostgreSQL**.

---

## What Changed

### Before (SQLite)
- Database: SQLite file-based (`todos.db`)
- Suitable for: Development, small projects
- File: `go.mod` included `gorm.io/driver/sqlite`

### After (PostgreSQL)
- Database: PostgreSQL server
- Suitable for: Production, scalability, multi-user
- File: `go.mod` includes `gorm.io/driver/postgres`

---

## Installation & Setup

### 1. Install PostgreSQL

#### macOS
```bash
brew install postgresql@15
brew services start postgresql@15
```

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
```

#### Windows
Download from: https://www.postgresql.org/download/windows/

### 2. Create Database & User

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE todos;

# Create user
CREATE USER todouser WITH PASSWORD 'todopassword';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE todos TO todouser;

# Exit
\q
```

### 3. Configure Environment Variables

Create a `.env` file or export environment variables:

```bash
# Database Configuration
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=todouser
export DB_PASS=todopassword
export DB_NAME=todos
export DB_SSL=disable

# API Configuration
export PORT=8080
export GIN_MODE=debug
```

### 4. Start the API

```bash
# With environment variables set
go run main.go

# Or inline
DB_HOST=localhost DB_PORT=5432 DB_USER=todouser DB_PASS=todopassword DB_NAME=todos go run main.go
```

---

## Configuration

### Environment Variables Reference

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | localhost | PostgreSQL server host |
| `DB_PORT` | 5432 | PostgreSQL server port |
| `DB_USER` | postgres | Database user |
| `DB_PASS` | postgres | Database password |
| `DB_NAME` | todos | Database name |
| `DB_SSL` | disable | SSL mode (disable, require, prefer) |
| `PORT` | 8080 | API server port |
| `GIN_MODE` | debug | Gin mode (debug, release) |

### Connection String Format

The application generates a PostgreSQL connection string (DSN) automatically:

```
host=localhost port=5432 user=todouser password=todopassword dbname=todos sslmode=disable
```

---

## Database Schema

### Tables Created Automatically

The application uses GORM auto-migration. These tables are created on startup:

#### `users`
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at BIGINT,
    updated_at BIGINT,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
```

#### `categories`
```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    color VARCHAR(7),
    created_at BIGINT,
    updated_at BIGINT,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_categories_name ON categories(name);
```

#### `tags`
```sql
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    created_at BIGINT,
    updated_at BIGINT,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_tags_name ON tags(name);
```

#### `todos`
```sql
CREATE TABLE todos (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT false,
    priority VARCHAR(20) DEFAULT 'medium',
    status VARCHAR(20) DEFAULT 'todo',
    due_date TIMESTAMP,
    category_id INTEGER REFERENCES categories(id),
    user_id INTEGER REFERENCES users(id),
    created_at BIGINT,
    updated_at BIGINT,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_todos_status ON todos(status);
CREATE INDEX idx_todos_priority ON todos(priority);
CREATE INDEX idx_todos_category_id ON todos(category_id);
CREATE INDEX idx_todos_user_id ON todos(user_id);
CREATE INDEX idx_todos_due_date ON todos(due_date);
CREATE INDEX idx_todos_title ON todos(title);
```

#### `todo_tags` (Many-to-Many Junction Table)
```sql
CREATE TABLE todo_tags (
    todo_id INTEGER REFERENCES todos(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (todo_id, tag_id)
);
```

---

## Features Enabled by PostgreSQL

### 1. Full-Text Search
PostgreSQL supports advanced text search capabilities:
```sql
SELECT * FROM todos 
WHERE to_tsvector(title || ' ' || description) @@ plainto_tsquery('project');
```

### 2. Advanced Indexing
Multiple column indexes for better query performance:
```sql
CREATE INDEX idx_todos_status_priority ON todos(status, priority);
CREATE INDEX idx_todos_category_user ON todos(category_id, user_id);
```

### 3. JSON Support
Store complex data structures:
```sql
-- Example: Store metadata as JSON
ALTER TABLE todos ADD COLUMN metadata JSONB;
```

### 4. Connection Pooling
PostgreSQL supports connection pooling for better scalability.

### 5. Transactions
Full ACID compliance for multi-statement operations.

---

## Performance Optimizations

### Indexes Created Automatically

The application creates these indexes on startup for optimal performance:

```
- idx_todos_status (status column)
- idx_todos_priority (priority column)
- idx_todos_category_id (foreign key)
- idx_todos_user_id (foreign key)
- idx_todos_due_date (date filtering)
- idx_todos_title (search)
- idx_categories_name (unique)
- idx_tags_name (unique)
- idx_users_username (unique)
- idx_users_email (unique)
```

### Query Performance

PostgreSQL provides better performance for:
- Complex filtering with multiple conditions
- Sorting large datasets
- Aggregation queries (used in stats endpoint)
- Text search operations

---

## Migrating from SQLite

### Manual Migration Steps

If you have data in SQLite that you want to preserve:

#### 1. Export SQLite Data
```bash
sqlite3 todos.db .dump > export.sql
```

#### 2. Convert Schema
Modify the SQL file to be compatible with PostgreSQL:
- Remove SQLite-specific syntax
- Convert AUTOINCREMENT to SERIAL
- Remove PRAGMA statements

#### 3. Import to PostgreSQL
```bash
psql -U todouser -d todos -f export.sql
```

### Using Data Migration Tools

Alternatively, use tools like:
- **pgloader**: Automatic SQLite to PostgreSQL migration
- **dbt**: Data build tool for transformations
- **Python script**: Custom migration logic

---

## Troubleshooting

### Connection Refused

```
Error: failed to connect to `host=localhost user=postgres database=postgres: 
dial error (dial tcp 127.0.0.1:5432: connect: connection refused)`
```

**Solution**: Ensure PostgreSQL is running
```bash
# macOS
brew services start postgresql@15

# Linux
sudo systemctl start postgresql

# Check status
psql -U postgres -c "SELECT version();"
```

### Authentication Failed

```
Error: password authentication failed for user "todouser"
```

**Solution**: Verify credentials in environment variables
```bash
# Test connection
psql -h localhost -U todouser -d todos
```

### Database Does Not Exist

```
Error: database "todos" does not exist
```

**Solution**: Create the database
```bash
psql -U postgres -c "CREATE DATABASE todos;"
```

### Port Already in Use

```
Error: listen tcp :8080: bind: address already in use
```

**Solution**: Use different port
```bash
PORT=3000 go run main.go
```

---

## Production Deployment

### 1. Create Dedicated Database User

```sql
CREATE USER todoapp WITH PASSWORD 'strong_random_password';
GRANT CONNECT ON DATABASE todos TO todoapp;
GRANT USAGE ON SCHEMA public TO todoapp;
GRANT CREATE ON SCHEMA public TO todoapp;
```

### 2. Configure SSL

```bash
# Generate SSL certificate
openssl req -x509 -newkey rsa:4096 -keyout server.key -out server.crt -days 365 -nodes

# Update environment variable
export DB_SSL=require
```

### 3. Connection Pooling

Use PgBouncer or pgpool for connection pooling:

```ini
# pgbouncer.ini
[databases]
todos = host=localhost port=5432 user=todoapp password=strong_password dbname=todos

[pgbouncer]
pool_mode = transaction
max_client_conn = 1000
```

### 4. Backup Strategy

```bash
# Full backup
pg_dump -U todoapp -d todos > backup_$(date +%Y%m%d).sql

# Compressed backup
pg_dump -U todoapp -d todos | gzip > backup_$(date +%Y%m%d).sql.gz

# Scheduled backup (cron)
0 2 * * * pg_dump -U todoapp -d todos | gzip > /backups/todos_$(date +\%Y\%m\%d).sql.gz
```

### 5. Monitoring

```bash
# Check database size
psql -U todoapp -d todos -c "
SELECT pg_size_pretty(pg_database_size('todos')) as db_size;"

# Check index usage
psql -U todoapp -d todos -c "
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch 
FROM pg_stat_user_indexes 
ORDER BY idx_scan DESC;"

# Check slow queries
psql -U todoapp -d todos -c "
SELECT query, calls, mean_time 
FROM pg_stat_statements 
ORDER BY mean_time DESC LIMIT 10;"
```

---

## Environment Variables Examples

### Development
```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=todos
DB_SSL=disable
PORT=8080
GIN_MODE=debug
```

### Testing
```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=testuser
DB_PASS=testpass
DB_NAME=todos_test
DB_SSL=disable
PORT=8080
GIN_MODE=test
```

### Production
```bash
DB_HOST=prod-db.example.com
DB_PORT=5432
DB_USER=todoapp
DB_PASS=<strong_password_from_vault>
DB_NAME=todos
DB_SSL=require
PORT=80
GIN_MODE=release
```

---

## Code Changes Summary

### Modified Files

1. **go.mod**
   - Removed: `gorm.io/driver/sqlite`
   - Added: `gorm.io/driver/postgres`

2. **config/config.go**
   - Added PostgreSQL connection parameters
   - Added `GetDSN()` method for connection string

3. **database/db.go**
   - Changed driver from SQLite to PostgreSQL
   - Added automatic index creation
   - Improved initialization logging

4. **main.go**
   - Changed to use `GetDSN()` from config

### No Changes Required

- All models remain the same
- All handlers work unchanged
- All routes remain the same
- All middleware unchanged
- API behavior identical

---

## Testing the Migration

### 1. Start PostgreSQL
```bash
# Ensure PostgreSQL is running
psql -U postgres -c "SELECT version();"
```

### 2. Run the Application
```bash
go run main.go
```

### 3. Test API
```bash
# Health check
curl http://localhost:8080/health

# Create user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"pass123"}'

# Get users
curl http://localhost:8080/api/users | jq '.'
```

### 4. Verify Database
```bash
psql -U todouser -d todos -c "SELECT * FROM users;"
```

---

## Rollback to SQLite

If you need to roll back to SQLite:

```bash
# Revert go.mod
git checkout go.mod go.sum

# Restore config/config.go and database/db.go if needed
git checkout config/config.go database/db.go

# Rebuild
go mod tidy
go build -o todo-app
```

---

## Docker Deployment

### Dockerfile Example

```dockerfile
FROM golang:1.25-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o todo-app

FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/todo-app .

EXPOSE 8080
CMD ["./todo-app"]
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: todouser
      POSTGRES_PASSWORD: todopassword
      POSTGRES_DB: todos
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      DB_USER: todouser
      DB_PASS: todopassword
      DB_NAME: todos
      DB_SSL: disable
      PORT: 8080
      GIN_MODE: release
    depends_on:
      - postgres

volumes:
  postgres_data:
```

---

## Performance Comparison

| Aspect | SQLite | PostgreSQL |
|--------|--------|------------|
| **Concurrent Users** | Limited | Unlimited |
| **Data Size** | < 1GB | > 100GB |
| **Full-Text Search** | Basic | Advanced |
| **Transactions** | Limited | Full ACID |
| **Replication** | Not built-in | Yes |
| **Backup** | File-based | Streaming |
| **Query Speed** | Fast for small | Optimized for large |
| **Connection Pool** | Not needed | Recommended |

---

## Next Steps

1. **Verify Setup**: Run API and test endpoints
2. **Configure Backups**: Set up automated PostgreSQL backups
3. **Monitor Performance**: Use PostgreSQL monitoring tools
4. **Scale**: Add read replicas or partitioning as needed
5. **Secure**: Use strong passwords and SSL in production

---

## References

- PostgreSQL Documentation: https://www.postgresql.org/docs/
- GORM PostgreSQL Driver: https://gorm.io/docs/dialects/postgres.html
- pgBouncer: https://www.pgbouncer.org/
- Backup Strategies: https://www.postgresql.org/docs/current/backup.html

---

**Status**: ✅ PostgreSQL Migration Complete

The API is now running on PostgreSQL and ready for production deployment!
