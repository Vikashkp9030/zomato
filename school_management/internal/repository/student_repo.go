package repository

import (
	"database/sql"
	"errors"
	"time"

	"school-management/internal/models"
)

type StudentRepository struct {
	db *sql.DB
}

func NewStudentRepository(db *sql.DB) *StudentRepository {
	return &StudentRepository{db: db}
}

func (r *StudentRepository) Create(student *models.Student) error {
	query := `INSERT INTO students (first_name, last_name, email, phone, date_of_birth, gender, enrollment_date, class_id, status, created_at, updated_at)
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`

	result, err := r.db.Exec(query, student.FirstName, student.LastName, student.Email, student.Phone,
		student.DateOfBirth, student.Gender, student.EnrollmentDate, student.ClassID, student.Status, time.Now(), time.Now())
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	student.ID = int(id)
	return nil
}

func (r *StudentRepository) GetByID(id int) (*models.Student, error) {
	query := `SELECT id, first_name, last_name, email, phone, date_of_birth, gender, enrollment_date, class_id, status, created_at, updated_at
	          FROM students WHERE id = ?`

	student := &models.Student{}
	err := r.db.QueryRow(query, id).Scan(
		&student.ID, &student.FirstName, &student.LastName, &student.Email, &student.Phone,
		&student.DateOfBirth, &student.Gender, &student.EnrollmentDate, &student.ClassID, &student.Status, &student.CreatedAt, &student.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("student not found")
		}
		return nil, err
	}

	return student, nil
}

func (r *StudentRepository) GetByClassID(classID int) ([]*models.Student, error) {
	query := `SELECT id, first_name, last_name, email, phone, date_of_birth, gender, enrollment_date, class_id, status, created_at, updated_at
	          FROM students WHERE class_id = ? AND status = 'Active'`

	rows, err := r.db.Query(query, classID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var students []*models.Student
	for rows.Next() {
		student := &models.Student{}
		err := rows.Scan(
			&student.ID, &student.FirstName, &student.LastName, &student.Email, &student.Phone,
			&student.DateOfBirth, &student.Gender, &student.EnrollmentDate, &student.ClassID, &student.Status, &student.CreatedAt, &student.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		students = append(students, student)
	}

	return students, rows.Err()
}

func (r *StudentRepository) Update(student *models.Student) error {
	query := `UPDATE students SET first_name = ?, last_name = ?, email = ?, phone = ?, date_of_birth = ?, gender = ?, class_id = ?, status = ?, updated_at = ?
	          WHERE id = ?`

	_, err := r.db.Exec(query, student.FirstName, student.LastName, student.Email, student.Phone,
		student.DateOfBirth, student.Gender, student.ClassID, student.Status, time.Now(), student.ID)
	return err
}

func (r *StudentRepository) Delete(id int) error {
	query := `DELETE FROM students WHERE id = ?`
	_, err := r.db.Exec(query, id)
	return err
}

func (r *StudentRepository) List(limit, offset int) ([]*models.Student, error) {
	query := `SELECT id, first_name, last_name, email, phone, date_of_birth, gender, enrollment_date, class_id, status, created_at, updated_at
	          FROM students ORDER BY created_at DESC LIMIT ? OFFSET ?`

	rows, err := r.db.Query(query, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var students []*models.Student
	for rows.Next() {
		student := &models.Student{}
		err := rows.Scan(
			&student.ID, &student.FirstName, &student.LastName, &student.Email, &student.Phone,
			&student.DateOfBirth, &student.Gender, &student.EnrollmentDate, &student.ClassID, &student.Status, &student.CreatedAt, &student.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		students = append(students, student)
	}

	return students, rows.Err()
}

func (r *StudentRepository) GetStudentPerformance(studentID int) (map[string]interface{}, error) {
	query := `
	SELECT
		AVG(er.marks_obtained) as average_marks,
		COUNT(CASE WHEN er.status = 'Passed' THEN 1 END) as passed_exams,
		COUNT(CASE WHEN er.status = 'Failed' THEN 1 END) as failed_exams,
		COUNT(DISTINCT er.exam_id) as total_exams
	FROM exam_results er
	WHERE er.student_id = ?
	`

	result := make(map[string]interface{})
	var avgMarks sql.NullFloat64
	var passedExams, failedExams, totalExams int

	err := r.db.QueryRow(query, studentID).Scan(&avgMarks, &passedExams, &failedExams, &totalExams)
	if err != nil {
		return nil, err
	}

	if avgMarks.Valid {
		result["average_marks"] = avgMarks.Float64
	}
	result["passed_exams"] = passedExams
	result["failed_exams"] = failedExams
	result["total_exams"] = totalExams

	return result, nil
}
