package middleware

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/vikashkp9030/zomato/shared/pkg/logger"
)

func LoggingMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		traceID := uuid.New().String()
		c.Set("trace_id", traceID)

		start := time.Now()
		path := c.Request.URL.Path
		method := c.Request.Method

		c.Next()

		duration := time.Since(start)
		statusCode := c.Writer.Status()

		logger.Info("HTTP Request",
			"trace_id", traceID,
			"method", method,
			"path", path,
			"status_code", statusCode,
			"duration_ms", duration.Milliseconds(),
		)
	}
}
