package main

import (
	"fmt"
	"net/http/httputil"
	"net/url"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/spf13/viper"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
	"github.com/vikashkp9030/zomato/shared/pkg/middleware"
)

func init() {
	godotenv.Load()
	viper.SetDefault("GATEWAY_PORT", "8000")
	viper.SetDefault("USER_SERVICE_URL", "http://localhost:8001")
	viper.SetDefault("RESTAURANT_SERVICE_URL", "http://localhost:8002")
	viper.SetDefault("ORDER_SERVICE_URL", "http://localhost:8003")
	viper.SetDefault("PAYMENT_SERVICE_URL", "http://localhost:8004")
	viper.SetDefault("DELIVERY_SERVICE_URL", "http://localhost:8005")
	viper.SetDefault("REVIEW_SERVICE_URL", "http://localhost:8006")
	viper.SetDefault("NOTIFICATION_SERVICE_URL", "http://localhost:8007")
	viper.SetDefault("ADMIN_SERVICE_URL", "http://localhost:8008")
}

type ServiceProxy struct {
	name string
	url  string
}

func newReverseProxy(targetURL string) *httputil.ReverseProxy {
	target, _ := url.Parse(targetURL)
	proxy := httputil.NewSingleHostReverseProxy(target)

	originalDirector := proxy.Director
	proxy.Director = func(req *http.Request) {
		originalDirector(req)
		req.Header.Set("X-Forwarded-Host", req.Header.Get("Host"))
	}

	return proxy
}

func main() {
	logger.Init(os.Getenv("ENV"))

	router := gin.Default()
	router.Use(middleware.CORSMiddleware())
	router.Use(middleware.LoggingMiddleware())

	// Service proxies
	services := map[string]ServiceProxy{
		"user":         {name: "User Service", url: viper.GetString("USER_SERVICE_URL")},
		"restaurant":   {name: "Restaurant Service", url: viper.GetString("RESTAURANT_SERVICE_URL")},
		"order":        {name: "Order Service", url: viper.GetString("ORDER_SERVICE_URL")},
		"payment":      {name: "Payment Service", url: viper.GetString("PAYMENT_SERVICE_URL")},
		"delivery":     {name: "Delivery Service", url: viper.GetString("DELIVERY_SERVICE_URL")},
		"review":       {name: "Review Service", url: viper.GetString("REVIEW_SERVICE_URL")},
		"notification": {name: "Notification Service", url: viper.GetString("NOTIFICATION_SERVICE_URL")},
		"admin":        {name: "Admin Service", url: viper.GetString("ADMIN_SERVICE_URL")},
	}

	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":   "ok",
			"service":  "api-gateway",
			"timestamp": time.Now(),
		})
	})

	// Service health checks
	router.GET("/health/services", func(c *gin.Context) {
		status := make(map[string]interface{})
		for name, service := range services {
			resp, err := http.Get(service.url + "/health")
			if err == nil && resp.StatusCode == 200 {
				status[name] = "ok"
				resp.Body.Close()
			} else {
				status[name] = "down"
			}
		}
		c.JSON(200, status)
	})

	// Route to API documentation
	router.GET("/docs", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"documentation": "API Documentation",
			"version":       "1.0.0",
			"endpoints": map[string]string{
				"users":        "/api/v1/users",
				"restaurants":  "/api/v1/restaurants",
				"orders":       "/api/v1/orders",
				"payments":     "/api/v1/payments",
				"deliveries":   "/api/v1/deliveries",
				"reviews":      "/api/v1/reviews",
				"notifications": "/api/v1/notifications",
				"admin":        "/api/v1/admin",
			},
		})
	})

	// Route all /api/v1/* requests to appropriate services
	router.Any("/api/v1/users/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["user"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/restaurants/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["restaurant"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/orders/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["order"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/cart/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["order"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/payments/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["payment"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/wallet/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["payment"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/methods/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["payment"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/deliveries/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["delivery"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/reviews/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["review"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/notifications/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["notification"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	router.Any("/api/v1/admin/*path", func(c *gin.Context) {
		proxy := newReverseProxy(services["admin"].url)
		proxy.ServeHTTP(c.Writer, c.Request)
	})

	port := viper.GetString("GATEWAY_PORT")
	logger.Info("API Gateway starting", "port", port)
	router.Run(fmt.Sprintf(":%s", port))
}

import "net/http"
