package models

import "time"

type Transport struct {
	ID            int       `json:"id"`
	StudentID     int       `json:"student_id"`
	RouteID       int       `json:"route_id"`
	RouteName     string    `json:"route_name"`
	BusNumber     string    `json:"bus_number"`
	PickupPoint   string    `json:"pickup_point"`
	DropoffPoint  string    `json:"dropoff_point"`
	PickupTime    string    `json:"pickup_time"`
	DropoffTime   string    `json:"dropoff_time"`
	DriverName    string    `json:"driver_name"`
	DriverPhone   string    `json:"driver_phone"`
	Status        string    `json:"status"` // active, inactive
	Fee           float64   `json:"fee"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type TransportRoute struct {
	ID            int       `json:"id"`
	RouteName     string    `json:"route_name"`
	BusNumber     string    `json:"bus_number"`
	DriverName    string    `json:"driver_name"`
	DriverPhone   string    `json:"driver_phone"`
	Stops         []string  `json:"stops"`
	StartTime     string    `json:"start_time"`
	EndTime       string    `json:"end_time"`
	Status        string    `json:"status"`
	StudentCount  int       `json:"student_count"`
	Capacity      int       `json:"capacity"`
}

type TransportResponse struct {
	StudentID     int       `json:"student_id"`
	StudentName   string    `json:"student_name"`
	RouteName     string    `json:"route_name"`
	BusNumber     string    `json:"bus_number"`
	PickupPoint   string    `json:"pickup_point"`
	DropoffPoint  string    `json:"dropoff_point"`
	PickupTime    string    `json:"pickup_time"`
	DropoffTime   string    `json:"dropoff_time"`
	DriverName    string    `json:"driver_name"`
	DriverPhone   string    `json:"driver_phone"`
	Status        string    `json:"status"`
	Fee           float64   `json:"fee"`
}