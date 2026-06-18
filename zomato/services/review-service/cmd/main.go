package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/services/review-service/internal/handler"
	"github.com/vikashkp9030/zomato/services/review-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/review-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8006")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "reviews_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	jwtManager := auth.NewJWTManager(viper.GetString("JWT_SECRET"), 15*60, 7*24*60*60)

	reviewRepo := repository.NewReviewRepository(pgDB)
	reviewUsecase := usecase.NewReviewUsecase(reviewRepo)
	reviewHandler := handler.NewReviewHandler(reviewUsecase)

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1")
	{
		reviews := v1.Group("/reviews")
		{
			reviews.GET("/restaurant/:restId", reviewHandler.GetRestaurantReviews)
			reviews.GET("/dish/:dishId", reviewHandler.GetDishReviews)

			protected := reviews.Group("")
			protected.Use(middleware.AuthMiddleware(jwtManager))
			{
				protected.POST("", reviewHandler.CreateReview)
				protected.PUT("/:id", reviewHandler.UpdateReview)
				protected.DELETE("/:id", reviewHandler.DeleteReview)
				protected.GET("/user", reviewHandler.GetUserReviews)
				protected.POST("/:id/like", reviewHandler.LikeReview)
				protected.DELETE("/:id/like", reviewHandler.UnlikeReview)
			}
		}
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "review-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Review Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
