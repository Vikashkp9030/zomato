package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8007")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "notifications_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	_ = pgDB

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1")
	{
		v1.GET("/notifications", func(c *gin.Context) {
			c.JSON(200, gin.H{"notifications": []string{}})
		})
		v1.GET("/notifications/:id", func(c *gin.Context) {
			c.JSON(200, gin.H{"notification": "sample"})
		})
		v1.PUT("/notifications/:id/read", func(c *gin.Context) {
			c.JSON(200, gin.H{"message": "marked as read"})
		})
		v1.DELETE("/notifications/:id", func(c *gin.Context) {
			c.JSON(204, nil)
		})
		v1.POST("/notifications/preferences", func(c *gin.Context) {
			c.JSON(201, gin.H{"message": "preferences saved"})
		})
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "notification-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Notification Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
