package models

import "time"

type Hostel struct {
	ID            int       `json:"id"`
	HostelName    string    `json:"hostel_name"`
	Location      string    `json:"location"`
	Capacity      int       `json:"capacity"`
	Status        string    `json:"status"`
	WardenName    string    `json:"warden_name"`
	WardenPhone   string    `json:"warden_phone"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type HostelAllocation struct {
	ID            int       `json:"id"`
	StudentID     int       `json:"student_id"`
	HostelID      int       `json:"hostel_id"`
	RoomNumber    string    `json:"room_number"`
	BedNumber     int       `json:"bed_number"`
	AllocationDate time.Time `json:"allocation_date"`
	Status        string    `json:"status"` // active, inactive
	Fee           float64   `json:"fee"`
	CreatedAt     time.Time `json:"created_at"`
}

type HostelResponse struct {
	ID            int       `json:"id"`
	HostelName    string    `json:"hostel_name"`
	Location      string    `json:"location"`
	Capacity      int       `json:"capacity"`
	OccupancyRate float64   `json:"occupancy_rate"`
	CurrentStudents int     `json:"current_students"`
	Status        string    `json:"status"`
	WardenName    string    `json:"warden_name"`
}

type RoomAllocation struct {
	RoomNumber    string    `json:"room_number"`
	BedNumber     int       `json:"bed_number"`
	StudentName   string    `json:"student_name"`
	StudentID     int       `json:"student_id"`
	AllocationDate time.Time `json:"allocation_date"`
	Status        string    `json:"status"`
}