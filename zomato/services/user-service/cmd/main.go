package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/services/user-service/internal/handler"
	"github.com/vikashkp9030/zomato/services/user-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/user-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/cache"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8001")
	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", "5432")
	viper.SetDefault("REDIS_ADDR", "localhost:6379")
	viper.SetDefault("JWT_SECRET", "your-secret-key")
}

func main() {
	logger.Init(os.Getenv("ENV"))
	defer func() {
		if r := recover(); r != nil {
			logger.Fatal("Application crashed", "error", r)
		}
	}()

	// Database Setup
	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "users_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	// Redis Setup
	redisCache, err := cache.NewRedisCache(viper.GetString("REDIS_ADDR"))
	if err != nil {
		logger.Warn("Redis connection failed, continuing without cache", "error", err.Error())
	}

	// JWT Manager
	jwtManager := auth.NewJWTManager(
		viper.GetString("JWT_SECRET"),
		15*60,
		7*24*60*60,
	)

	// Repositories
	userRepo := repository.NewUserRepository(pgDB)

	// Use Cases
	userUsecase := usecase.NewUserUsecase(userRepo, jwtManager, redisCache)

	// Handlers
	userHandler := handler.NewUserHandler(userUsecase, jwtManager)

	// Gin Router
	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	// Routes
	v1 := router.Group("/api/v1")
	{
		users := v1.Group("/users")
		{
			users.POST("/register", userHandler.Register)
			users.POST("/login", userHandler.Login)
			users.POST("/refresh", userHandler.Refresh)
			users.POST("/verify-email", userHandler.VerifyEmail)

			protected := users.Group("")
			protected.Use(middleware.AuthMiddleware(jwtManager))
			{
				protected.GET("/profile", userHandler.GetProfile)
				protected.PUT("/profile", userHandler.UpdateProfile)
				protected.DELETE("/profile", userHandler.DeleteProfile)
				protected.POST("/change-password", userHandler.ChangePassword)
				protected.POST("/logout", userHandler.Logout)

				// Addresses
				protected.GET("/addresses", userHandler.GetAddresses)
				protected.POST("/addresses", userHandler.AddAddress)
				protected.PUT("/addresses/:id", userHandler.UpdateAddress)
				protected.DELETE("/addresses/:id", userHandler.DeleteAddress)

				// Wishlist
				protected.GET("/wishlist", userHandler.GetWishlist)
				protected.POST("/wishlist", userHandler.AddToWishlist)
				protected.DELETE("/wishlist/:id", userHandler.RemoveFromWishlist)
			}
		}
	}

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "user-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("User Service starting", "port", port)
	if err := router.Run(fmt.Sprintf(":%s", port)); err != nil {
		logger.Fatal("Server failed to start", "error", err.Error())
	}
}
