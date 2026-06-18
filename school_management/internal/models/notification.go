package models

import "time"

type Notification struct {
	ID        int       `json:"id"`
	UserID    int       `json:"user_id"`
	Title     string    `json:"title"`
	Message   string    `json:"message"`
	Type      string    `json:"type"` // info, warning, alert, success
	Category  string    `json:"category"` // academic, fees, attendance, general
	IsRead    bool      `json:"is_read"`
	ReadAt    *time.Time `json:"read_at"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type NotificationResponse struct {
	ID        int       `json:"id"`
	Title     string    `json:"title"`
	Message   string    `json:"message"`
	Type      string    `json:"type"`
	Category  string    `json:"category"`
	IsRead    bool      `json:"is_read"`
	ReadAt    *time.Time `json:"read_at"`
	CreatedAt time.Time `json:"created_at"`
}

type NotificationStats struct {
	TotalNotifications int `json:"total_notifications"`
	UnreadCount       int `json:"unread_count"`
	AcademicCount     int `json:"academic_count"`
	FeesCount         int `json:"fees_count"`
	AttendanceCount   int `json:"attendance_count"`
	GeneralCount      int `json:"general_count"`
}

type NotificationPreferences struct {
	UserID                int  `json:"user_id"`
	EnableEmailNotifs     bool `json:"enable_email_notifs"`
	EnablePushNotifs      bool `json:"enable_push_notifs"`
	EnableAcademic        bool `json:"enable_academic"`
	EnableFees            bool `json:"enable_fees"`
	EnableAttendance      bool `json:"enable_attendance"`
	EnableGeneral         bool `json:"enable_general"`
}