package config

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/joho/godotenv"
)

type Database struct {
	Host     string
	Port     string
	User     string
	Password string
	Name     string
}

type Server struct {
	Host string
	Port string
}

type JWT struct {
	Secret           string
	Expiry           time.Duration
	RefreshExpiry    time.Duration
}

type Email struct {
	SMTPHost string
	SMTPPort int
	SMTPUser string
	SMTPPass string
}

type AppConfig struct {
	Database Database
	Server   Server
	JWT      JWT
	Email    Email
	AppEnv   string
	LogLevel string
}

func LoadConfig() (*AppConfig, error) {
	godotenv.Load()
	jwtExpiry, err := time.ParseDuration(getEnv("JWT_EXPIRY","15m"))
	if err != nil {
		jwtExpiry = 15 * time.Minute
	}
   


	refreshExpiry, err := time.ParseDuration(getEnv("REFRESH_TOKEN_EXPIRY", "7d"))
	if err != nil {
		refreshExpiry = 7 * 24 * time.Hour
	}

	smtpPort, _ := strconv.Atoi(getEnv("SMTP_PORT", "587"))

	config := &AppConfig{
		Database: Database{
			Host:     getEnv("DB_HOST", "localhost"),
			Port:     getEnv("DB_PORT", "3306"),
			User:     getEnv("DB_USER", "root"),
			Password: getEnv("DB_PASSWORD", ""),
			Name:     getEnv("DB_NAME", "school_management"),
		},
		Server: Server{
			Host: getEnv("SERVER_HOST", "0.0.0.0"),
			Port: getEnv("SERVER_PORT", "8080"),
		},
		JWT: JWT{
			Secret:        getEnv("JWT_SECRET", "your-secret-key"),
			Expiry:        jwtExpiry,
			RefreshExpiry: refreshExpiry,
		},
		Email: Email{
			SMTPHost: getEnv("SMTP_HOST", "smtp.gmail.com"),
			SMTPPort: smtpPort,
			SMTPUser: getEnv("SMTP_USER", ""),
			SMTPPass: getEnv("SMTP_PASSWORD", ""),
		},
		AppEnv:   getEnv("APP_ENV", "development"),
		LogLevel: getEnv("LOG_LEVEL", "info"),
	}

	return config, nil
}

func (d *Database) DSN() string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		d.User,
		d.Password,
		d.Host,
		d.Port,
		d.Name,
	)
}

func getEnv(key, defaultVal string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultVal
}
