package middleware

import (
	"log"
	"net/http"
)

func CORSMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		origin := r.Header.Get("Origin")

		log.Printf("🔄 CORS Request - Origin: %s | Method: %s | Path: %s", origin, r.Method, r.RequestURI)

		// ⚠️ IMPORTANT: When credentials=true, origin CANNOT be "*"
		// For development, accept localhost from any port
		// For production, whitelist specific origins
		allowOrigin := origin
		if allowOrigin == "" {
			// Fallback: allow any localhost
			allowOrigin = "*"
		} else if origin != "*" {
			// Only set specific origin (not wildcard) if credentials are true
			allowOrigin = origin
		}

		// Set CORS headers
		w.Header().Set("Access-Control-Allow-Origin", allowOrigin)
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, PATCH, HEAD")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Authorization, Content-Type, X-CSRF-Token, X-Requested-With, Content-Length, Origin")
		w.Header().Set("Access-Control-Expose-Headers", "Content-Type, Authorization, X-Total-Count, X-Page-Number")
		w.Header().Set("Access-Control-Max-Age", "86400")

		log.Printf("✅ CORS Headers Set - Origin: %s | Credentials: true | Methods: GET,POST,PUT,DELETE,OPTIONS,PATCH,HEAD", allowOrigin)

		// Handle preflight requests (OPTIONS)
		if r.Method == http.MethodOptions {
			log.Printf("✅ CORS Preflight OK - Origin: %s", origin)
			w.WriteHeader(http.StatusNoContent)
			return
		}

		next.ServeHTTP(w, r)
	})
}
