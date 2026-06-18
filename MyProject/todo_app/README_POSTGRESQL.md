# TODO API - PostgreSQL Version

**Status**: ✅ Migrated from SQLite to PostgreSQL

This is the **production-ready** version of the TODO API using PostgreSQL as the database backend.

---

## Quick Start

### 1. Install PostgreSQL

```bash
# macOS
brew install postgresql@15
brew services start postgresql@15

# Linux
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql

# Windows
# Download from: https://www.postgresql.org/download/windows/
```

### 2. Set Up Database

**Option A: Automatic Setup (Recommended)**
```bash
chmod +x setup-postgres.sh
./setup-postgres.sh
```

**Option B: Manual Setup**
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

### 3. Configure Environment

Create `.env` file:
```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=todouser
DB_PASS=todopassword
DB_NAME=todos
DB_SSL=disable
PORT=8080
GIN_MODE=debug
```

Or export variables:
```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=todouser
export DB_PASS=todopassword
export DB_NAME=todos
export DB_SSL=disable
export PORT=8080
export GIN_MODE=debug
```

### 4. Run the API

```bash
# Using .env file
source .env && go run main.go

# Or directly
go run main.go
```

### 5. Test It Works

```bash
curl http://localhost:8080/health
```

Expected response:
```json
{"message":"API is running"}
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | localhost | PostgreSQL host |
| `DB_PORT` | 5432 | PostgreSQL port |
| `DB_USER` | postgres | Database user |
| `DB_PASS` | postgres | Database password |
| `DB_NAME` | todos | Database name |
| `DB_SSL` | disable | SSL mode |
| `PORT` | 8080 | API port |
| `GIN_MODE` | debug | Gin mode |

---

## API Endpoints

All 40+ endpoints are available. Examples:

```bash
# Health check
curl http://localhost:8080/health

# Create user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"username":"john","email":"john@example.com","password":"pass123"}'

# Create category
curl -X POST http://localhost:8080/api/categories \
  -H "Content-Type: application/json" \
  -d '{"name":"Work","color":"#EF4444"}'

# Create todo
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Build app","priority":"high","category_id":1,"user_id":1}'

# Get todos
curl "http://localhost:8080/api/todos?status=todo&priority=high" | jq '.'

# Get statistics
curl http://localhost:8080/api/todos/stats | jq '.'
```

See `API_COMPLETE_REFERENCE.md` for full documentation.

---

## File Structure

```
todo_app/
├── main.go                         Entry point
├── config/config.go               PostgreSQL configuration
├── database/db.go                 Database initialization
├── models/todo.go                 Data models
├── handlers/
│   ├── todo_handler.go
│   ├── category_handler.go
│   ├── tag_handler.go
│   └── user_handler.go
├── routes/routes.go               API routes
├── middleware/cors.go             CORS middleware
│
├── Documentation
│   ├── README_POSTGRESQL.md       This file
│   ├── POSTGRESQL_MIGRATION.md    Migration details
│   ├── API_COMPLETE_REFERENCE.md  API documentation
│   ├── API_TESTING_GUIDE.md       Testing guide
│   ├── CLAUDE.md                  Development guide
│   └── ...
│
├── setup-postgres.sh              Setup script
└── .env.example                   Example config
```

---

## Database Schema

Automatically created on first run:

- **users** - User accounts
- **categories** - Todo categories
- **tags** - Todo tags
- **todos** - Todo items
- **todo_tags** - Many-to-many relationship

With automatic indexes for performance.

---

## Features

✅ **40+ API Endpoints**
- CRUD for todos, categories, tags, users
- Advanced filtering and search
- Pagination and sorting
- Bulk operations
- Statistics and analytics

✅ **PostgreSQL Benefits**
- Scalability for large datasets
- Full ACID transactions
- Advanced indexing
- Connection pooling support
- Replication support

✅ **Production Ready**
- Error handling
- Soft deletes
- Relationship management
- Auto-migration
- Performance indexes

---

## Performance

PostgreSQL provides better performance than SQLite for:
- Concurrent users (unlimited vs limited)
- Large datasets (> 1GB)
- Complex queries
- Full-text search
- Multi-user scenarios

### Benchmarks (Approximate)

| Operation | SQLite | PostgreSQL |
|-----------|--------|------------|
| Single user, 1000 todos | Fast | Fast |
| 10 concurrent users | Medium | Excellent |
| 100 concurrent users | Slow | Excellent |
| Full-text search | Basic | Advanced |
| Complex filtering | Slow | Fast |

---

## Docker Deployment

### Dockerfile

```dockerfile
FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download && go build -o todo-app

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/todo-app .
EXPOSE 8080
CMD ["./todo-app"]
```

### Docker Compose

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
    depends_on:
      - postgres

volumes:
  postgres_data:
```

Run with: `docker-compose up`

---

## Production Checklist

- [ ] Install PostgreSQL on production server
- [ ] Create dedicated database user
- [ ] Set strong password
- [ ] Enable SSL (`DB_SSL=require`)
- [ ] Set `GIN_MODE=release`
- [ ] Configure backups
- [ ] Set up monitoring
- [ ] Use connection pooling
- [ ] Configure firewall
- [ ] Set up logging

---

## Troubleshooting

### Connection Refused
```bash
# Check if PostgreSQL is running
psql -U postgres -c "SELECT version();"

# Start PostgreSQL
brew services start postgresql@15  # macOS
sudo systemctl start postgresql    # Linux
```

### Authentication Failed
```bash
# Verify credentials
export PGPASSWORD='todopassword'
psql -h localhost -U todouser -d todos -c "SELECT 1;"
```

### Database Does Not Exist
```bash
# Create database
psql -U postgres -c "CREATE DATABASE todos;"
```

### Port Already in Use
```bash
# Use different port
PORT=3000 go run main.go
```

---

## Maintenance

### Backup Database
```bash
pg_dump -U todouser -d todos > backup.sql

# Compressed
pg_dump -U todouser -d todos | gzip > backup.sql.gz
```

### Restore Database
```bash
psql -U todouser -d todos < backup.sql
```

### Check Database Size
```bash
psql -U todouser -d todos -c \
  "SELECT pg_size_pretty(pg_database_size('todos'));"
```

### View Tables
```bash
psql -U todouser -d todos -c "\dt"
```

---

## Code Changes from SQLite

### Modified Files
1. **go.mod** - PostgreSQL driver added
2. **config/config.go** - PostgreSQL configuration
3. **database/db.go** - PostgreSQL initialization
4. **main.go** - DSN parameter

### Unchanged Files
- All handlers
- All models
- All routes
- All middleware
- API behavior identical

---

## Next Steps

1. **Set Up**: Run `./setup-postgres.sh`
2. **Start API**: `source .env && go run main.go`
3. **Test**: Use curl examples above
4. **Deploy**: Docker Compose or manual setup
5. **Scale**: Add replicas, connection pooling, monitoring

---

## Documentation

| File | Purpose |
|------|---------|
| README_POSTGRESQL.md | This file - PostgreSQL setup |
| POSTGRESQL_MIGRATION.md | Detailed migration guide |
| API_COMPLETE_REFERENCE.md | Full API documentation |
| API_TESTING_GUIDE.md | Testing examples |
| CLAUDE.md | Development guide |
| setup-postgres.sh | Automated setup script |

---

## Support

For issues or questions:
1. Check `POSTGRESQL_MIGRATION.md` for detailed information
2. Review error messages carefully
3. Check PostgreSQL logs
4. Verify environment variables
5. Test connection with `psql`

---

**Version**: 2.0 (PostgreSQL)  
**Status**: Production Ready  
**Database**: PostgreSQL 15+  
**Last Updated**: June 12, 2026

Ready for production deployment! 🚀
