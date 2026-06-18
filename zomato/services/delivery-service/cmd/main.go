package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/services/delivery-service/internal/handler"
	"github.com/vikashkp9030/zomato/services/delivery-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/delivery-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8005")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "deliveries_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	jwtManager := auth.NewJWTManager(viper.GetString("JWT_SECRET"), 15*60, 7*24*60*60)

	deliveryRepo := repository.NewDeliveryRepository(pgDB)
	deliveryUsecase := usecase.NewDeliveryUsecase(deliveryRepo)
	deliveryHandler := handler.NewDeliveryHandler(deliveryUsecase)

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1")
	{
		deliveries := v1.Group("/deliveries")
		{
			deliveries.GET("/track/:orderId", deliveryHandler.TrackDelivery)

			protected := deliveries.Group("")
			protected.Use(middleware.AuthMiddleware(jwtManager))
			{
				protected.POST("/assign", deliveryHandler.AssignDelivery)
				protected.PUT("/partner/location", deliveryHandler.UpdatePartnerLocation)
				protected.PUT("/partner/status", deliveryHandler.UpdatePartnerStatus)
				protected.GET("/partner/earnings", deliveryHandler.GetPartnerEarnings)
				protected.GET("/partner/orders", deliveryHandler.GetPartnerOrders)
				protected.POST("/partner/accept/:orderId", deliveryHandler.AcceptOrder)
				protected.POST("/partner/reject/:orderId", deliveryHandler.RejectOrder)
				protected.PUT("/partner/complete/:orderId", deliveryHandler.CompleteOrder)
			}
		}
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "delivery-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Delivery Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
