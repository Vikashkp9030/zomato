package repository

import (
	"context"
	"database/sql"
	"school-management/internal/models"
)

type ClassRepository struct {
	conn *sql.DB
}

func NewClassRepository(conn *sql.DB) *ClassRepository {
	return &ClassRepository{conn: conn}
}

func (r *ClassRepository) Create(ctx context.Context, class *models.Class) (int64, error) {
	query := `INSERT INTO classes (class_name, grade_level, section, capacity, class_teacher_id, room_number)
	VALUES (?, ?, ?, ?, ?, ?)`

	result, err := r.conn.ExecContext(ctx, query,
		class.ClassName, class.GradeLevel, class.Section,
		class.Capacity, class.ClassTeacherID, class.RoomNumber)
	if err != nil {
		return 0, err
	}

	return result.LastInsertId()
}

func (r *ClassRepository) GetByID(ctx context.Context, id int) (*models.Class, error) {
	query := `SELECT id, class_name, grade_level, section, capacity, class_teacher_id, room_number, created_at, updated_at
	FROM classes WHERE id = ?`

	var class models.Class
	err := r.conn.QueryRowContext(ctx, query, id).Scan(
		&class.ID, &class.ClassName, &class.GradeLevel, &class.Section,
		&class.Capacity, &class.ClassTeacherID, &class.RoomNumber,
		&class.CreatedAt, &class.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &class, nil
}

func (r *ClassRepository) GetAll(ctx context.Context, limit int, offset int) ([]models.Class, error) {
	query := `SELECT id, class_name, grade_level, section, capacity, class_teacher_id, room_number, created_at, updated_at
	FROM classes ORDER BY grade_level, section LIMIT ? OFFSET ?`

	rows, err := r.conn.QueryContext(ctx, query, limit, offset)
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

func (r *ClassRepository) Update(ctx context.Context, class *models.Class) error {
	query := `UPDATE classes SET class_name = ?, grade_level = ?, section = ?, capacity = ?,
	class_teacher_id = ?, room_number = ?, updated_at = NOW() WHERE id = ?`

	_, err := r.conn.ExecContext(ctx, query,
		class.ClassName, class.GradeLevel, class.Section,
		class.Capacity, class.ClassTeacherID, class.RoomNumber, class.ID)

	return err
}

func (r *ClassRepository) Delete(ctx context.Context, id int) error {
	query := `DELETE FROM classes WHERE id = ?`
	_, err := r.conn.ExecContext(ctx, query, id)
	return err
}

func (r *ClassRepository) GetByGradeLevel(ctx context.Context, gradeLevel int) ([]models.Class, error) {
	query := `SELECT id, class_name, grade_level, section, capacity, class_teacher_id, room_number, created_at, updated_at
	FROM classes WHERE grade_level = ? ORDER BY section`

	rows, err := r.conn.QueryContext(ctx, query, gradeLevel)
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

func (r *ClassRepository) GetCount(ctx context.Context) (int, error) {
	query := `SELECT COUNT(*) FROM classes`
	var count int
	err := r.conn.QueryRowContext(ctx, query).Scan(&count)
	return count, err
}

func (r *ClassRepository) CheckCapacity(ctx context.Context, classID int) (int, error) {
	query := `SELECT capacity FROM classes WHERE id = ?`
	var capacity int
	err := r.conn.QueryRowContext(ctx, query, classID).Scan(&capacity)
	return capacity, err
}

func (r *ClassRepository) GetStudentCount(ctx context.Context, classID int) (int, error) {
	query := `SELECT COUNT(*) FROM students WHERE class_id = ? AND status = 'active'`
	var count int
	err := r.conn.QueryRowContext(ctx, query, classID).Scan(&count)
	return count, err
}
