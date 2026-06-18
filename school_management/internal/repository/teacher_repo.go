package repository

import (
	"context"
	"database/sql"
	"school-management/internal/models"
)

type TeacherRepository struct {
	conn *sql.DB
}

func NewTeacherRepository(conn *sql.DB) *TeacherRepository {
	return &TeacherRepository{conn: conn}
}

func (r *TeacherRepository) Create(ctx context.Context, teacher *models.Teacher) (int64, error) {
	query := `INSERT INTO teachers (first_name, last_name, email, phone, hire_date, specialization, salary, experience_years)
	VALUES (?, ?, ?, ?, ?, ?, ?, ?)`

	result, err := r.conn.ExecContext(ctx, query,
		teacher.FirstName, teacher.LastName, teacher.Email, teacher.Phone,
		teacher.HireDate, teacher.Specialization, teacher.Salary, teacher.ExperienceYears)
	if err != nil {
		return 0, err
	}

	return result.LastInsertId()
}

func (r *TeacherRepository) GetByID(ctx context.Context, id int) (*models.Teacher, error) {
	query := `SELECT id, first_name, last_name, email, phone, hire_date, specialization, salary, experience_years, created_at, updated_at
	FROM teachers WHERE id = ?`

	var teacher models.Teacher
	err := r.conn.QueryRowContext(ctx, query, id).Scan(
		&teacher.ID, &teacher.FirstName, &teacher.LastName, &teacher.Email, &teacher.Phone,
		&teacher.HireDate, &teacher.Specialization, &teacher.Salary, &teacher.ExperienceYears,
		&teacher.CreatedAt, &teacher.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &teacher, nil
}

func (r *TeacherRepository) GetAll(ctx context.Context, limit int, offset int) ([]models.Teacher, error) {
	query := `SELECT id, first_name, last_name, email, phone, hire_date, specialization, salary, experience_years, created_at, updated_at
	FROM teachers ORDER BY last_name, first_name LIMIT ? OFFSET ?`

	rows, err := r.conn.QueryContext(ctx, query, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var teachers []models.Teacher
	for rows.Next() {
		var teacher models.Teacher
		err := rows.Scan(
			&teacher.ID, &teacher.FirstName, &teacher.LastName, &teacher.Email, &teacher.Phone,
			&teacher.HireDate, &teacher.Specialization, &teacher.Salary, &teacher.ExperienceYears,
			&teacher.CreatedAt, &teacher.UpdatedAt)
		if err != nil {
			return nil, err
		}
		teachers = append(teachers, teacher)
	}

	return teachers, rows.Err()
}

func (r *TeacherRepository) Update(ctx context.Context, teacher *models.Teacher) error {
	query := `UPDATE teachers SET first_name = ?, last_name = ?, email = ?, phone = ?,
	hire_date = ?, specialization = ?, salary = ?, experience_years = ?, updated_at = NOW() WHERE id = ?`

	_, err := r.conn.ExecContext(ctx, query,
		teacher.FirstName, teacher.LastName, teacher.Email, teacher.Phone,
		teacher.HireDate, teacher.Specialization, teacher.Salary, teacher.ExperienceYears,
		teacher.ID)

	return err
}

func (r *TeacherRepository) Delete(ctx context.Context, id int) error {
	query := `DELETE FROM teachers WHERE id = ?`
	_, err := r.conn.ExecContext(ctx, query, id)
	return err
}

func (r *TeacherRepository) GetBySpecialization(ctx context.Context, specialization string) ([]models.Teacher, error) {
	query := `SELECT id, first_name, last_name, email, phone, hire_date, specialization, salary, experience_years, created_at, updated_at
	FROM teachers WHERE specialization = ? ORDER BY last_name`

	rows, err := r.conn.QueryContext(ctx, query, specialization)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var teachers []models.Teacher
	for rows.Next() {
		var teacher models.Teacher
		err := rows.Scan(
			&teacher.ID, &teacher.FirstName, &teacher.LastName, &teacher.Email, &teacher.Phone,
			&teacher.HireDate, &teacher.Specialization, &teacher.Salary, &teacher.ExperienceYears,
			&teacher.CreatedAt, &teacher.UpdatedAt)
		if err != nil {
			return nil, err
		}
		teachers = append(teachers, teacher)
	}

	return teachers, rows.Err()
}

func (r *TeacherRepository) GetByEmail(ctx context.Context, email string) (*models.Teacher, error) {
	query := `SELECT id, first_name, last_name, email, phone, hire_date, specialization, salary, experience_years, created_at, updated_at
	FROM teachers WHERE email = ?`

	var teacher models.Teacher
	err := r.conn.QueryRowContext(ctx, query, email).Scan(
		&teacher.ID, &teacher.FirstName, &teacher.LastName, &teacher.Email, &teacher.Phone,
		&teacher.HireDate, &teacher.Specialization, &teacher.Salary, &teacher.ExperienceYears,
		&teacher.CreatedAt, &teacher.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &teacher, nil
}

func (r *TeacherRepository) GetCount(ctx context.Context) (int, error) {
	query := `SELECT COUNT(*) FROM teachers`
	var count int
	err := r.conn.QueryRowContext(ctx, query).Scan(&count)
	return count, err
}

func (r *TeacherRepository) CheckEmailExists(ctx context.Context, email string) (bool, error) {
	query := `SELECT COUNT(*) FROM teachers WHERE email = ?`
	var count int
	err := r.conn.QueryRowContext(ctx, query, email).Scan(&count)
	return count > 0, err
}

func (r *TeacherRepository) GetAssignedClasses(ctx context.Context, teacherID int) ([]models.Class, error) {
	query := `SELECT id, class_name, grade_level, section, capacity, class_teacher_id, room_number, created_at, updated_at
	FROM classes WHERE class_teacher_id = ?`

	rows, err := r.conn.QueryContext(ctx, query, teacherID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var classes []models.Class
	for rows.Next() {
		var class models.Class
		err := rows.Scan(
			&class.ID, &class.ClassName, &class.GradeLevel, &class.Section,
			&class.Capacity, &class.ClassTeacherID, &class.RoomNumber,
			&class.CreatedAt, &class.UpdatedAt)
		if err != nil {
			return nil, err
		}
		classes = append(classes, class)
	}

	return classes, rows.Err()
}
