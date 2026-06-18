package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/handler"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/restaurant-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/cache"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8002")
	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", "5432")
	viper.SetDefault("REDIS_ADDR", "localhost:6379")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "restaurants_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	redisCache, _ := cache.NewRedisCache(viper.GetString("REDIS_ADDR"))
	jwtManager := auth.NewJWTManager(viper.GetString("JWT_SECRET"), 15*60, 7*24*60*60)

	restaurantRepo := repository.NewRestaurantRepository(pgDB)
	restaurantUsecase := usecase.NewRestaurantUsecase(restaurantRepo, redisCache)
	restaurantHandler := handler.NewRestaurantHandler(restaurantUsecase)

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1")
	{
		restaurants := v1.Group("/restaurants")
		{
			restaurants.GET("", restaurantHandler.ListRestaurants)
			restaurants.GET("/search", restaurantHandler.SearchRestaurants)
			restaurants.GET("/cuisines", restaurantHandler.GetCuisines)
			restaurants.GET("/:id", restaurantHandler.GetRestaurant)
			restaurants.GET("/:id/menu", restaurantHandler.GetMenu)
			restaurants.GET("/:id/reviews", restaurantHandler.GetReviews)
			restaurants.GET("/:id/rating", restaurantHandler.GetRating)

			protected := restaurants.Group("")
			protected.Use(middleware.AuthMiddleware(jwtManager))
			{
				protected.POST("", restaurantHandler.CreateRestaurant)
				protected.PUT("/:id", restaurantHandler.UpdateRestaurant)
				protected.DELETE("/:id", restaurantHandler.DeleteRestaurant)
				protected.POST("/:id/menu/categories", restaurantHandler.AddCategory)
				protected.POST("/:id/menu/dishes", restaurantHandler.AddDish)
				protected.PUT("/menu/dishes/:dishId", restaurantHandler.UpdateDish)
				protected.DELETE("/menu/dishes/:dishId", restaurantHandler.DeleteDish)
				protected.POST("/:id/follow", restaurantHandler.FollowRestaurant)
				protected.DELETE("/:id/follow", restaurantHandler.UnfollowRestaurant)
				protected.GET("/owner/restaurants", restaurantHandler.GetOwnerRestaurants)
			}
		}
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "restaurant-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Restaurant Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
