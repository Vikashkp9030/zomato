package db

import (
	"context"
	"fmt"

	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type PostgresConfig struct {
	Host     string
	Port     string
	User     string
	Password string
	DBName   string
	SSLMode  string
}

func NewPostgresDB(cfg PostgresConfig) (*gorm.DB, error) {
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.DBName, cfg.SSLMode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		logger.Error("Failed to connect to PostgreSQL", "error", err.Error())
		return nil, err
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	sqlDB.SetMaxOpenConns(25)
	sqlDB.SetMaxIdleConns(5)

	ctx, cancel := context.WithTimeout(context.Background(), 5*1)
	defer cancel()

	if err := sqlDB.PingContext(ctx); err != nil {
		logger.Error("Failed to ping PostgreSQL", "error", err.Error())
		return nil, err
	}

	logger.Info("Connected to PostgreSQL", "database", cfg.DBName)
	return db, nil
}
