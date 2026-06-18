package middleware

import (
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/vikashkp9030/zomato/shared/pkg/auth"
	"github.com/vikashkp9030/zomato/shared/pkg/errors"
)

func AuthMiddleware(jwtManager *auth.JWTManager) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(401, gin.H{"error": "missing authorization header"})
			c.Abort()
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(401, gin.H{"error": "invalid authorization header format"})
			c.Abort()
			return
		}

		claims, err := jwtManager.VerifyAccessToken(parts[1])
		if err != nil {
			c.JSON(401, gin.H{"error": "invalid token"})
			c.Abort()
			return
		}

		c.Set("user_id", claims.UserID)
		c.Set("email", claims.Email)
		c.Set("role", claims.Role)
		c.Next()
	}
}

func RoleMiddleware(requiredRoles ...auth.Role) gin.HandlerFunc {
	return func(c *gin.Context) {
		roleVal, exists := c.Get("role")
		if !exists {
			c.JSON(401, gin.H{"error": "role not found in context"})
			c.Abort()
			return
		}

		userRole := roleVal.(auth.Role)
		allowed := false
		for _, role := range requiredRoles {
			if userRole == role {
				allowed = true
				break
			}
		}

		if !allowed {
			err := errors.NewForbiddenError("insufficient permissions")
			c.JSON(err.StatusCode, gin.H{"error": err.Message})
			c.Abort()
			return
		}

		c.Next()
	}
}
