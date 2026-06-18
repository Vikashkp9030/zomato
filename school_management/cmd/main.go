package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"school-management/config"
	"school-management/internal/database"
	"school-management/internal/middleware"
	"school-management/internal/routes"
)

func main() {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	db, err := database.New(cfg.Database.DSN())
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	log.Println("✓ Database connected successfully")

	router := mux.NewRouter()

	router.Use(middleware.LoggerMiddleware)
	router.Use(middleware.CORSMiddleware)

	// Handle OPTIONS requests for CORS preflight on all paths
	router.PathPrefix("/").Methods("OPTIONS").HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusNoContent)
	})

	routes.RegisterRoutes(router, db, cfg)

	addr := cfg.Server.Host + ":" + cfg.Server.Port
	log.Printf("🚀 Server starting on %s", addr)

	if err := http.ListenAndServe(addr, router); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
