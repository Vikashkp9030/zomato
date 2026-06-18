package database

import (
	"log"
	"todo_app/models"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB(dsn string) {
	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Auto migrate all models
	err = DB.AutoMigrate(
		&models.User{},
		&models.Category{},
		&models.Tag{},
		&models.Todo{},
	)
	if err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}

	// Create indexes for better performance
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_todos_status ON todos(status)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_todos_priority ON todos(priority)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_todos_category_id ON todos(category_id)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_todos_user_id ON todos(user_id)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_todos_due_date ON todos(due_date)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_todos_title ON todos(title)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_tags_name ON tags(name)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_users_username ON users(username)")
	DB.Exec("CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)")

	log.Println("PostgreSQL database initialized successfully")
}
