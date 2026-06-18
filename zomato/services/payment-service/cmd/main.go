package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/services/payment-service/internal/handler"
	"github.com/vikashkp9030/zomato/services/payment-service/internal/repository"
	"github.com/vikashkp9030/zomato/services/payment-service/internal/usecase"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/db"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("SERVICE_PORT", "8004")
}

func main() {
	logger.Init(os.Getenv("ENV"))

	pgDB, err := db.NewPostgresDB(db.PostgresConfig{
		Host:     viper.GetString("DB_HOST"),
		Port:     viper.GetString("DB_PORT"),
		User:     viper.GetString("DB_USER"),
		Password: viper.GetString("DB_PASSWORD"),
		DBName:   "payments_db",
		SSLMode:  "disable",
	})
	if err != nil {
		logger.Fatal("Database connection failed", "error", err.Error())
	}

	jwtManager := auth.NewJWTManager(viper.GetString("JWT_SECRET"), 15*60, 7*24*60*60)

	paymentRepo := repository.NewPaymentRepository(pgDB)
	paymentUsecase := usecase.NewPaymentUsecase(paymentRepo)
	paymentHandler := handler.NewPaymentHandler(paymentUsecase)

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	v1 := router.Group("/api/v1")
	v1.Use(middleware.AuthMiddleware(jwtManager))
	{
		payments := v1.Group("/payments")
		{
			payments.POST("/initiate", paymentHandler.InitiatePayment)
			payments.POST("/confirm", paymentHandler.ConfirmPayment)
			payments.GET("/:id", paymentHandler.GetPayment)
			payments.GET("/history", paymentHandler.GetHistory)
			payments.POST("/refund", paymentHandler.RefundPayment)

			wallet := v1.Group("/wallet")
			{
				wallet.GET("/balance", paymentHandler.GetWalletBalance)
				wallet.POST("/add", paymentHandler.AddToWallet)
				wallet.POST("/withdraw", paymentHandler.WithdrawFromWallet)
			}

			methods := v1.Group("/methods")
			{
				methods.GET("", paymentHandler.GetPaymentMethods)
				methods.POST("", paymentHandler.AddPaymentMethod)
				methods.DELETE("/:id", paymentHandler.DeletePaymentMethod)
			}
		}
	}

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "service": "payment-service"})
	})

	port := viper.GetString("SERVICE_PORT")
	logger.Info("Payment Service starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}
