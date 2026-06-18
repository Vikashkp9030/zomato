package repository

import (
	"database/sql"
	"errors"
	"time"

	"school-management/internal/models"
)

type AttendanceRepository struct {
	db *sql.DB
}

func NewAttendanceRepository(db *sql.DB) *AttendanceRepository {
	return &AttendanceRepository{db: db}
}

func (r *AttendanceRepository) Create(attendance *models.Attendance) error {
	query := `INSERT INTO attendance (student_id, class_id, attendance_date, status, remarks, created_at, updated_at)
	          VALUES (?, ?, ?, ?, ?, ?, ?)`

	result, err := r.db.Exec(query, attendance.StudentID, attendance.ClassID, attendance.AttendanceDate, attendance.Status, attendance.Remarks, time.Now(), time.Now())
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	attendance.ID = int(id)
	return nil
}

func (r *AttendanceRepository) GetStudentAttendance(studentID int, startDate, endDate time.Time) ([]*models.Attendance, error) {
	query := `SELECT id, student_id, class_id, attendance_date, status, remarks, created_at, updated_at
	          FROM attendance WHERE student_id = ? AND attendance_date BETWEEN ? AND ? ORDER BY attendance_date DESC`

	rows, err := r.db.Query(query, studentID, startDate, endDate)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var attendances []*models.Attendance
	for rows.Next() {
		a := &models.Attendance{}
		err := rows.Scan(
			&a.ID, &a.StudentID, &a.ClassID, &a.AttendanceDate, &a.Status, &a.Remarks, &a.CreatedAt, &a.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		attendances = append(attendances, a)
	}

	return attendances, rows.Err()
}

func (r *AttendanceRepository) GetClassAttendance(classID int, attendanceDate time.Time) ([]*models.Attendance, error) {
	query := `SELECT id, student_id, class_id, attendance_date, status, remarks, created_at, updated_at
	          FROM attendance WHERE class_id = ? AND attendance_date = ? ORDER BY student_id ASC`

	rows, err := r.db.Query(query, classID, attendanceDate)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var attendances []*models.Attendance
	for rows.Next() {
		a := &models.Attendance{}
		err := rows.Scan(
			&a.ID, &a.StudentID, &a.ClassID, &a.AttendanceDate, &a.Status, &a.Remarks, &a.CreatedAt, &a.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		attendances = append(attendances, a)
	}

	return attendances, rows.Err()
}

func (r *AttendanceRepository) GetAttendanceSummary(studentID int) (map[string]interface{}, error) {
	query := `
	SELECT
		COUNT(*) as total_days,
		SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) as present_days,
		SUM(CASE WHEN status = 'Absent' THEN 1 ELSE 0 END) as absent_days,
		SUM(CASE WHEN status = 'Late' THEN 1 ELSE 0 END) as late_days,
		ROUND(SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as attendance_percentage
	FROM attendance
	WHERE student_id = ?
	`

	result := make(map[string]interface{})
	var totalDays, presentDays, absentDays, lateDays int
	var percentage sql.NullFloat64

	err := r.db.QueryRow(query, studentID).Scan(&totalDays, &presentDays, &absentDays, &lateDays, &percentage)
	if err != nil {
		return nil, err
	}

	result["total_days"] = totalDays
	result["present_days"] = presentDays
	result["absent_days"] = absentDays
	result["late_days"] = lateDays
	if percentage.Valid {
		result["attendance_percentage"] = percentage.Float64
	}

	return result, nil
}

func (r *AttendanceRepository) Update(attendance *models.Attendance) error {
	query := `UPDATE attendance SET status = ?, remarks = ?, updated_at = ? WHERE id = ?`
	_, err := r.db.Exec(query, attendance.Status, attendance.Remarks, time.Now(), attendance.ID)
	return err
}

func (r *AttendanceRepository) Delete(id int) error {
	query := `DELETE FROM attendance WHERE id = ?`
	_, err := r.db.Exec(query, id)
	return err
}

func (r *AttendanceRepository) GetByID(id int) (*models.Attendance, error) {
	query := `SELECT id, student_id, class_id, attendance_date, status, remarks, created_at, updated_at
	          FROM attendance WHERE id = ?`

	a := &models.Attendance{}
	err := r.db.QueryRow(query, id).Scan(
		&a.ID, &a.StudentID, &a.ClassID, &a.AttendanceDate, &a.Status, &a.Remarks, &a.CreatedAt, &a.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("attendance record not found")
		}
		return nil, err
	}

	return a, nil
}
