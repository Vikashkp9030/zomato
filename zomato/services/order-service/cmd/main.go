package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/services/order-service/internal/handler"
	"github.com/vikashkp9030/zomato/services/order-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/order-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8003")
	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", "5432")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "orders_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	jwtManager := auth.NewJWTManager(viper.GetString("JWT_SECRET"), 15*60, 7*24*60*60)

	orderRepo := repository.NewOrderRepository(pgDB)
	orderUsecase := usecase.NewOrderUsecase(orderRepo)
	orderHandler := handler.NewOrderHandler(orderUsecase)

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1")
	{
		orders := v1.Group("/orders")
		{
			orders.GET("", middleware.AuthMiddleware(jwtManager), orderHandler.ListOrders)
			orders.GET("/:id", middleware.AuthMiddleware(jwtManager), orderHandler.GetOrder)
			orders.GET("/:id/track", orderHandler.TrackOrder)

			protected := orders.Group("")
			protected.Use(middleware.AuthMiddleware(jwtManager))
			{
				protected.POST("", orderHandler.CreateOrder)
				protected.PUT("/:id/status", orderHandler.UpdateOrderStatus)
				protected.PUT("/:id/cancel", orderHandler.CancelOrder)
				protected.POST("/estimate-delivery", orderHandler.EstimateDelivery)
			}

			cart := v1.Group("/cart")
			cart.Use(middleware.AuthMiddleware(jwtManager))
			{
				cart.GET("", orderHandler.GetCart)
				cart.POST("", orderHandler.AddToCart)
				cart.PUT("/:itemId", orderHandler.UpdateCartItem)
				cart.DELETE("/:itemId", orderHandler.RemoveFromCart)
				cart.DELETE("", orderHandler.ClearCart)
			}
		}
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "order-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Order Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
