package models

import "time"

type Payroll struct {
	ID               int       `json:"id"`
	EmployeeID       int       `json:"employee_id"`
	Month            string    `json:"month"`
	BaseSalary       float64   `json:"base_salary"`
	Allowances       float64   `json:"allowances"`
	Deductions       float64   `json:"deductions"`
	NetSalary        float64   `json:"net_salary"`
	Status           string    `json:"status"` // pending, processed, paid
	PaymentDate      *time.Time `json:"payment_date"`
	PaymentMethod    string    `json:"payment_method"`
	TransactionID    string    `json:"transaction_id"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

type PayrollResponse struct {
	ID              int       `json:"id"`
	EmployeeName    string    `json:"employee_name"`
	Month           string    `json:"month"`
	BaseSalary      float64   `json:"base_salary"`
	Allowances      float64   `json:"allowances"`
	Deductions      float64   `json:"deductions"`
	NetSalary       float64   `json:"net_salary"`
	Status          string    `json:"status"`
	PaymentDate     *time.Time `json:"payment_date"`
	PaymentMethod   string    `json:"payment_method"`
}

type PayslipResponse struct {
	EmployeeID      int       `json:"employee_id"`
	EmployeeName    string    `json:"employee_name"`
	Month           string    `json:"month"`
	BaseSalary      float64   `json:"base_salary"`
	Allowances      float64   `json:"allowances"`
	Deductions      float64   `json:"deductions"`
	NetSalary       float64   `json:"net_salary"`
	PaymentDate     *time.Time `json:"payment_date"`
	PaymentMethod   string    `json:"payment_method"`
}

type PayrollSummary struct {
	Month           string    `json:"month"`
	TotalEmployees  int       `json:"total_employees"`
	TotalSalary     float64   `json:"total_salary"`
	PendingPayroll  int       `json:"pending_payroll"`
	ProcessedPayroll int      `json:"processed_payroll"`
	PaidPayroll     int       `json:"paid_payroll"`
}