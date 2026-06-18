package models

import "time"

type LibraryBook struct {
	ID            int       `json:"id"`
	Title         string    `json:"title"`
	Author        string    `json:"author"`
	ISBN          string    `json:"isbn"`
	Category      string    `json:"category"`
	PublishedYear int       `json:"published_year"`
	TotalCopies   int       `json:"total_copies"`
	AvailableCopies int     `json:"available_copies"`
	Status        string    `json:"status"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type BookIssue struct {
	ID            int       `json:"id"`
	StudentID     int       `json:"student_id"`
	BookID        int       `json:"book_id"`
	IssueDate     time.Time `json:"issue_date"`
	DueDate       time.Time `json:"due_date"`
	ReturnDate    *time.Time `json:"return_date"`
	Status        string    `json:"status"` // issued, returned, overdue
	FineAmount    float64   `json:"fine_amount"`
	CreatedAt     time.Time `json:"created_at"`
}

type BookResponse struct {
	ID              int       `json:"id"`
	Title           string    `json:"title"`
	Author          string    `json:"author"`
	Category        string    `json:"category"`
	AvailableCopies int       `json:"available_copies"`
	TotalCopies     int       `json:"total_copies"`
	Status          string    `json:"status"`
}

type StudentBookIssue struct {
	StudentID     int       `json:"student_id"`
	StudentName   string    `json:"student_name"`
	BookTitle     string    `json:"book_title"`
	IssueDate     time.Time `json:"issue_date"`
	DueDate       time.Time `json:"due_date"`
	ReturnDate    *time.Time `json:"return_date"`
	Status        string    `json:"status"`
	FineAmount    float64   `json:"fine_amount"`
}