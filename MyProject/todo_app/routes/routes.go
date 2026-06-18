package routes

import (
	"todo_app/handlers"
	"todo_app/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine) {
	// Public Authentication Routes
	auth := router.Group("/api/auth")
	{
		auth.POST("/signup", handlers.Signup)
		auth.POST("/login", handlers.Login)
		auth.POST("/refresh", handlers.RefreshAccessToken)
		auth.POST("/request-reset", handlers.RequestPasswordReset)
		auth.POST("/confirm-reset", handlers.ConfirmPasswordReset)
	}

	// Protected routes - require authentication
	protected := router.Group("/api")
	protected.Use(middleware.AuthMiddleware())
	{
		// Change password and logout
		protectedAuth := protected.Group("/auth")
		{
			protectedAuth.POST("/change-password", handlers.ChangePassword)
			protectedAuth.POST("/logout", handlers.Logout)
		}

		// TODO API Routes
		todos := protected.Group("/todos")
		{
			todos.POST("", handlers.CreateTodo)
			todos.GET("", handlers.GetAllTodos)
			todos.GET("/:id", handlers.GetTodoByID)
			todos.PUT("/:id", handlers.UpdateTodo)
			todos.DELETE("/:id", handlers.DeleteTodo)
			todos.DELETE("", handlers.DeleteAllTodos)

			// Advanced todo operations
			todos.GET("/search", handlers.SearchTodos)
			todos.GET("/stats", handlers.GetTodoStats)
			todos.GET("/due/:date", handlers.GetDueDateTodos)
			todos.GET("/upcoming", handlers.GetUpcomingTodos)
			todos.POST("/bulk-update", handlers.BulkUpdateTodos)
			todos.POST("/bulk-delete", handlers.BulkDeleteTodos)
		}

		// Category API Routes
		categories := protected.Group("/categories")
		{
			categories.POST("", handlers.CreateCategory)
			categories.GET("", handlers.GetAllCategories)
			categories.GET("/:id", handlers.GetCategoryByID)
			categories.GET("/:id/todos", handlers.GetCategoryTodos)
			categories.PUT("/:id", handlers.UpdateCategory)
			categories.DELETE("/:id", handlers.DeleteCategory)
		}

		// Tag API Routes
		tags := protected.Group("/tags")
		{
			tags.POST("", handlers.CreateTag)
			tags.GET("", handlers.GetAllTags)
			tags.GET("/:id", handlers.GetTagByID)
			tags.GET("/:id/todos", handlers.GetTagTodos)
			tags.PUT("/:id", handlers.UpdateTag)
			tags.DELETE("/:id", handlers.DeleteTag)
		}

		// User API Routes
		users := protected.Group("/users")
		{
			users.POST("", handlers.CreateUser)
			users.GET("", handlers.GetAllUsers)
			users.GET("/:id", handlers.GetUserByID)
			users.GET("/:id/todos", handlers.GetUserTodos)
			users.PUT("/:id", handlers.UpdateUser)
			users.DELETE("/:id", handlers.DeleteUser)
		}
	}
}
