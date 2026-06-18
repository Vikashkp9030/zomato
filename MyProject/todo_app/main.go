package main

import (
	"log"
	"todo_app/config"
	"todo_app/database"
	"todo_app/middleware"
	"todo_app/routes"
	"todo_app/utils"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.LoadConfig()

	// Set JWT secret from config
	utils.SetJWTSecret(cfg.JWTSecret)

	// Initialize database with PostgreSQL connection string
	database.InitDB(cfg.GetDSN())

	// Set Gin mode
	gin.SetMode(cfg.GinMode)

	// Create router
	router := gin.New()

	// Apply middleware
	router.Use(gin.Logger())
	router.Use(gin.Recovery())
	router.Use(middleware.CORSMiddleware())

	// Setup routes
	routes.SetupRoutes(router)

	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "API is running",
		})
	})

	// Start server
	log.Printf("Server starting on port %s", cfg.Port)
	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
