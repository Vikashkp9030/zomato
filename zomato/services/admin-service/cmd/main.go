package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8008")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "admin_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	jwtManager := auth.NewJWTManager(viper.GetString("JWT_SECRET"), 15*60, 7*24*60*60)

	_ = pgDB

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1/admin")
	v1.Use(middleware.AuthMiddleware(jwtManager))
	v1.Use(middleware.RoleMiddleware(auth.RoleAdmin))
	{
		v1.GET("/users", func(c *gin.Context) {
			c.JSON(200, gin.H{"users": []string{}})
		})
		v1.PUT("/users/:id/status", func(c *gin.Context) {
			c.JSON(200, gin.H{"message": "user status updated"})
		})
		v1.GET("/restaurants/pending", func(c *gin.Context) {
			c.JSON(200, gin.H{"restaurants": []string{}})
		})
		v1.PUT("/restaurants/:id/approve", func(c *gin.Context) {
			c.JSON(200, gin.H{"message": "restaurant approved"})
		})
		v1.PUT("/restaurants/:id/reject", func(c *gin.Context) {
			c.JSON(200, gin.H{"message": "restaurant rejected"})
		})
		v1.GET("/analytics/orders", func(c *gin.Context) {
			c.JSON(200, gin.H{"total_orders": 1000, "revenue": 250000})
		})
		v1.GET("/analytics/revenue", func(c *gin.Context) {
			c.JSON(200, gin.H{"total_revenue": 250000})
		})
		v1.GET("/system/health", func(c *gin.Context) {
			c.JSON(200, gin.H{"status": "healthy", "uptime": "99.9%"})
		})
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "admin-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Admin Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
