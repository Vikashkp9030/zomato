package handlers

import (
	"net/http"
	"time"
	"todo_app/database"
	"todo_app/models"

	"github.com/gin-gonic/gin"
)

// CreateTag creates a new tag
func CreateTag(c *gin.Context) {
	var req models.CreateTagRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	tag := models.Tag{
		Name:      req.Name,
		CreatedAt: time.Now().Unix(),
		UpdatedAt: time.Now().Unix(),
	}

	if err := database.DB.Create(&tag).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create tag"})
		return
	}

	c.JSON(http.StatusCreated, tag)
}

// GetAllTags retrieves all tags
func GetAllTags(c *gin.Context) {
	var tags []models.Tag

	if err := database.DB.Find(&tags).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch tags"})
		return
	}

	c.JSON(http.StatusOK, tags)
}

// GetTagByID retrieves a specific tag
func GetTagByID(c *gin.Context) {
	id := c.Param("id")
	var tag models.Tag

	if err := database.DB.First(&tag, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tag not found"})
		return
	}

	c.JSON(http.StatusOK, tag)
}

// GetTagTodos retrieves all todos with a specific tag
func GetTagTodos(c *gin.Context) {
	id := c.Param("id")
	var todos []models.Todo

	if err := database.DB.Joins("JOIN todo_tags ON todos.id = todo_tags.todo_id").
		Where("todo_tags.tag_id = ?", id).Find(&todos).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch todos"})
		return
	}

	c.JSON(http.StatusOK, todos)
}

// UpdateTag updates a tag
func UpdateTag(c *gin.Context) {
	id := c.Param("id")
	var req models.UpdateTagRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var tag models.Tag
	if err := database.DB.First(&tag, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tag not found"})
		return
	}

	if err := database.DB.Model(&tag).Updates(models.Tag{
		Name:      req.Name,
		UpdatedAt: time.Now().Unix(),
	}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update tag"})
		return
	}

	database.DB.First(&tag, id)
	c.JSON(http.StatusOK, tag)
}

// DeleteTag deletes a tag
func DeleteTag(c *gin.Context) {
	id := c.Param("id")
	var tag models.Tag

	if err := database.DB.First(&tag, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tag not found"})
		return
	}

	if err := database.DB.Delete(&tag).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete tag"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Tag deleted successfully"})
}
