package handlers

import (
	"net/http"
	"strconv"
	"strings"
	"time"
	"todo_app/database"
	"todo_app/models"

	"github.com/gin-gonic/gin"
)

// CreateTodo creates a new todo item
func CreateTodo(c *gin.Context) {
	var req models.CreateTodoRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	todo := models.Todo{
		Title:       req.Title,
		Description: req.Description,
		Priority:    models.PriorityMedium,
		Status:      models.StatusTodo,
		DueDate:     req.DueDate,
		CategoryID:  req.CategoryID,
		UserID:      req.UserID,
		CreatedAt:   time.Now().Unix(),
		UpdatedAt:   time.Now().Unix(),
	}

	if req.Priority != "" {
		todo.Priority = req.Priority
	}
	if req.Status != "" {
		todo.Status = req.Status
	}

	tx := database.DB.Create(&todo)
	if tx.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create todo"})
		return
	}

	// Associate tags if provided
	if len(req.TagIDs) > 0 {
		database.DB.Model(&todo).Association("Tags").Append(req.TagIDs)
	}

	// Reload with associations
	database.DB.Preload("Category").Preload("Tags").Preload("User").First(&todo, todo.ID)
	c.JSON(http.StatusCreated, todo)
}

// GetAllTodos retrieves all todos with optional filters and pagination
func GetAllTodos(c *gin.Context) {
	var todos []models.Todo
	var total int64

	query := database.DB.Preload("Category").Preload("Tags").Preload("User")

	// Apply filters
	if status := c.Query("status"); status != "" {
		query = query.Where("status = ?", status)
	}
	if priority := c.Query("priority"); priority != "" {
		query = query.Where("priority = ?", priority)
	}
	if completed := c.Query("completed"); completed != "" {
		query = query.Where("completed = ?", completed == "true")
	}
	if categoryID := c.Query("category_id"); categoryID != "" {
		query = query.Where("category_id = ?", categoryID)
	}
	if userID := c.Query("user_id"); userID != "" {
		query = query.Where("user_id = ?", userID)
	}
	if tagID := c.Query("tag_id"); tagID != "" {
		query = query.Joins("JOIN todo_tags ON todos.id = todo_tags.todo_id").
			Where("todo_tags.tag_id = ?", tagID)
	}
	if search := c.Query("search"); search != "" {
		query = query.Where("title ILIKE ? OR description ILIKE ?", "%"+search+"%", "%"+search+"%")
	}

	// Get total count
	query.Model(&models.Todo{}).Count(&total)

	// Apply sorting
	sortBy := c.DefaultQuery("sort_by", "created_at")
	order := c.DefaultQuery("order", "desc")
	query = query.Order(sortBy + " " + order)

	// Apply pagination
	page := 1
	if p := c.Query("page"); p != "" {
		if pInt, err := strconv.Atoi(p); err == nil && pInt > 0 {
			page = pInt
		}
	}
	limit := 10
	if l := c.Query("limit"); l != "" {
		if lInt, err := strconv.Atoi(l); err == nil && lInt > 0 {
			limit = lInt
		}
	}

	offset := (page - 1) * limit
	query = query.Offset(offset).Limit(limit)

	if err := query.Find(&todos).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch todos"})
		return
	}

	totalPages := (int(total) + limit - 1) / limit
	response := models.PaginatedResponse{
		Data:       todos,
		Total:      total,
		Page:       page,
		Limit:      limit,
		TotalPages: totalPages,
	}

	c.JSON(http.StatusOK, response)
}

// GetTodoByID retrieves a specific todo by ID
func GetTodoByID(c *gin.Context) {
	id := c.Param("id")
	var todo models.Todo

	if err := database.DB.Preload("Category").Preload("Tags").Preload("User").
		First(&todo, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Todo not found"})
		return
	}

	c.JSON(http.StatusOK, todo)
}

// UpdateTodo updates a todo item
func UpdateTodo(c *gin.Context) {
	id := c.Param("id")
	var req models.UpdateTodoRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var todo models.Todo
	if err := database.DB.First(&todo, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Todo not found"})
		return
	}

	updates := map[string]interface{}{
		"updated_at": time.Now().Unix(),
	}

	if req.Title != nil {
		updates["title"] = *req.Title
	}
	if req.Description != nil {
		updates["description"] = *req.Description
	}
	if req.Completed != nil {
		updates["completed"] = *req.Completed
	}
	if req.Priority != nil {
		updates["priority"] = *req.Priority
	}
	if req.Status != nil {
		updates["status"] = *req.Status
	}
	if req.DueDate != nil {
		updates["due_date"] = req.DueDate
	}
	if req.CategoryID != nil {
		updates["category_id"] = req.CategoryID
	}
	if req.UserID != nil {
		updates["user_id"] = req.UserID
	}

	if err := database.DB.Model(&todo).Updates(updates).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update todo"})
		return
	}

	// Update tags if provided
	if len(req.TagIDs) > 0 {
		database.DB.Model(&todo).Association("Tags").Clear()
		database.DB.Model(&todo).Association("Tags").Append(req.TagIDs)
	}

	database.DB.Preload("Category").Preload("Tags").Preload("User").First(&todo, id)
	c.JSON(http.StatusOK, todo)
}

// DeleteTodo deletes a todo item
func DeleteTodo(c *gin.Context) {
	id := c.Param("id")
	var todo models.Todo

	if err := database.DB.First(&todo, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Todo not found"})
		return
	}

	if err := database.DB.Delete(&todo).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete todo"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Todo deleted successfully"})
}

// DeleteAllTodos deletes all todos
func DeleteAllTodos(c *gin.Context) {
	if err := database.DB.Exec("DELETE FROM todos").Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete all todos"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "All todos deleted successfully"})
}

// GetTodoStats returns statistics about todos
func GetTodoStats(c *gin.Context) {
	var stats models.StatsResponse
	now := time.Now()

	// Total todos
	database.DB.Model(&models.Todo{}).Count(&stats.TotalTodos)

	// Completed todos
	database.DB.Model(&models.Todo{}).Where("completed = ?", true).Count(&stats.CompletedTodos)

	// Pending todos
	database.DB.Model(&models.Todo{}).Where("completed = ?", false).Count(&stats.PendingTodos)

	// High priority todos
	database.DB.Model(&models.Todo{}).Where("priority = ?", models.PriorityHigh).
		Count(&stats.HighPriority)

	// Overdue todos
	database.DB.Model(&models.Todo{}).Where("due_date < ? AND completed = ?", now, false).
		Count(&stats.OverdueTodos)

	// Todos by category
	var categoryStats []struct {
		Name  string
		Count int64
	}
	database.DB.Model(&models.Todo{}).
		Select("categories.name, count(*) as count").
		Joins("LEFT JOIN categories ON todos.category_id = categories.id").
		Group("categories.name").
		Scan(&categoryStats)

	stats.TodoByCategory = make(map[string]int64)
	for _, cs := range categoryStats {
		stats.TodoByCategory[cs.Name] = cs.Count
	}

	// Todos by status
	var statusStats []struct {
		Status string
		Count  int64
	}
	database.DB.Model(&models.Todo{}).
		Select("status, count(*) as count").
		Group("status").
		Scan(&statusStats)

	stats.TodoByStatus = make(map[string]int64)
	for _, ss := range statusStats {
		stats.TodoByStatus[ss.Status] = ss.Count
	}

	c.JSON(http.StatusOK, stats)
}

// BulkUpdateTodos updates multiple todos
func BulkUpdateTodos(c *gin.Context) {
	var req struct {
		IDs    []uint   `json:"ids" binding:"required"`
		Status *string  `json:"status"`
		Priority *string `json:"priority"`
		Completed *bool  `json:"completed"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	updates := map[string]interface{}{
		"updated_at": time.Now().Unix(),
	}

	if req.Status != nil {
		updates["status"] = *req.Status
	}
	if req.Priority != nil {
		updates["priority"] = *req.Priority
	}
	if req.Completed != nil {
		updates["completed"] = *req.Completed
	}

	if err := database.DB.Model(&models.Todo{}).Where("id IN ?", req.IDs).
		Updates(updates).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update todos"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Todos updated successfully"})
}

// BulkDeleteTodos deletes multiple todos
func BulkDeleteTodos(c *gin.Context) {
	var req struct {
		IDs []uint `json:"ids" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := database.DB.Delete(&models.Todo{}, "id IN ?", req.IDs).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete todos"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Todos deleted successfully"})
}

// SearchTodos searches todos by keyword
func SearchTodos(c *gin.Context) {
	keyword := c.Query("q")
	if keyword == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Search keyword required"})
		return
	}

	var todos []models.Todo
	query := "%" + strings.ToLower(keyword) + "%"

	if err := database.DB.Preload("Category").Preload("Tags").Preload("User").
		Where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", query, query).
		Find(&todos).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Search failed"})
		return
	}

	c.JSON(http.StatusOK, todos)
}

// GetDueDateTodos retrieves todos due on a specific date
func GetDueDateTodos(c *gin.Context) {
	date := c.Query("date")
	if date == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Date parameter required (YYYY-MM-DD)"})
		return
	}

	var todos []models.Todo

	if err := database.DB.Preload("Category").Preload("Tags").Preload("User").
		Where("DATE(due_date) = ?", date).Find(&todos).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch todos"})
		return
	}

	c.JSON(http.StatusOK, todos)
}

// GetUpcomingTodos retrieves todos due in the next N days
func GetUpcomingTodos(c *gin.Context) {
	days := 7
	if d := c.Query("days"); d != "" {
		if dInt, err := strconv.Atoi(d); err == nil && dInt > 0 {
			days = dInt
		}
	}

	now := time.Now()
	future := now.AddDate(0, 0, days)

	var todos []models.Todo

	if err := database.DB.Preload("Category").Preload("Tags").Preload("User").
		Where("due_date BETWEEN ? AND ? AND completed = ?", now, future, false).
		Order("due_date ASC").
		Find(&todos).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch todos"})
		return
	}

	c.JSON(http.StatusOK, todos)
}
