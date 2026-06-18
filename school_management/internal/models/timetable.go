package models

import "time"

type Timetable struct {
	ID        int       `json:"id"`
	ClassID   int       `json:"class_id"`
	DayOfWeek string    `json:"day_of_week"`
	StartTime string    `json:"start_time"`
	EndTime   string    `json:"end_time"`
	SubjectID int       `json:"subject_id"`
	TeacherID int       `json:"teacher_id"`
	Room      string    `json:"room"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type TimetableResponse struct {
	ID        int       `json:"id"`
	ClassName string    `json:"class_name"`
	DayOfWeek string    `json:"day_of_week"`
	StartTime string    `json:"start_time"`
	EndTime   string    `json:"end_time"`
	Subject   string    `json:"subject"`
	Teacher   string    `json:"teacher"`
	Room      string    `json:"room"`
	CreatedAt time.Time `json:"created_at"`
}

type WeeklyTimetable struct {
	ClassName    string       `json:"class_name"`
	Schedule     []TimetableResponse `json:"schedule"`
}