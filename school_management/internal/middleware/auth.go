package middleware

import (
	"context"
	"net/http"
	"strings"

	"school-management/config"
	"school-management/internal/utils"
)

type ContextKey string

const UserContextKey ContextKey = "user"

func AuthMiddleware(cfg *config.AppConfig) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "missing authorization header")
				return
			}

			parts := strings.Split(authHeader, " ")
			if len(parts) != 2 || parts[0] != "Bearer" {
				utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", "invalid authorization header format")
				return
			}

			token := parts[1]
			claims, err := utils.ValidateToken(token, cfg)
			if err != nil {
				utils.ErrorResponse(w, http.StatusUnauthorized, "Unauthorized", err.Error())
				return
			}

			ctx := context.WithValue(r.Context(), UserContextKey, claims)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func GetUserFromContext(r *http.Request) *utils.Claims {
	claims, ok := r.Context().Value(UserContextKey).(*utils.Claims)
	if !ok {
		return nil
	}
	return claims
}
