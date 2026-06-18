package config

import (
	"fmt"
	"os"
)

type Config struct {
	Port      string
	DBHost    string
	DBPort    string
	DBUser    string
	DBPass    string
	DBName    string
	DBSSL     string
	GinMode   string
	JWTSecret string
}

func LoadConfig() *Config {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	dbHost := os.Getenv("DB_HOST")
	if dbHost == "" {
		dbHost = "localhost"
	}

	dbPort := os.Getenv("DB_PORT")
	if dbPort == "" {
		dbPort = "5432"
	}

	dbUser := os.Getenv("DB_USER")
	if dbUser == "" {
		dbUser = "postgres"
	}

	dbPass := os.Getenv("DB_PASS")
	if dbPass == "" {
		dbPass = "postgres"
	}

	dbName := os.Getenv("DB_NAME")
	if dbName == "" {
		dbName = "todos"
	}

	dbSSL := os.Getenv("DB_SSL")
	if dbSSL == "" {
		dbSSL = "disable"
	}

	ginMode := os.Getenv("GIN_MODE")
	if ginMode == "" {
		ginMode = "debug"
	}

	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		jwtSecret = "your-secret-key-min-32-chars-long-change-in-production"
	}

	return &Config{
		Port:      port,
		DBHost:    dbHost,
		DBPort:    dbPort,
		DBUser:    dbUser,
		DBPass:    dbPass,
		DBName:    dbName,
		DBSSL:     dbSSL,
		GinMode:   ginMode,
		JWTSecret: jwtSecret,
	}
}

// GetDSN returns the PostgreSQL connection string
func (c *Config) GetDSN() string {
	return fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		c.DBHost,
		c.DBPort,
		c.DBUser,
		c.DBPass,
		c.DBName,
		c.DBSSL,
	)
}
