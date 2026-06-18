package repository

import (
	"context"
	"database/sql"
	"school-management/internal/models"
)

type SubjectRepository struct {
	conn *sql.DB
}

func NewSubjectRepository(conn *sql.DB) *SubjectRepository {
	return &SubjectRepository{conn: conn}
}

func (r *SubjectRepository) Create(ctx context.Context, subject *models.Subject) (int64, error) {
	query := `INSERT INTO subjects (subject_name, subject_code, credits, description)
	VALUES (?, ?, ?, ?)`

	result, err := r.conn.ExecContext(ctx, query,
		subject.SubjectName, subject.SubjectCode, subject.Credits, subject.Description)
	if err != nil {
		return 0, err
	}

	return result.LastInsertId()
}

func (r *SubjectRepository) GetByID(ctx context.Context, id int) (*models.Subject, error) {
	query := `SELECT id, subject_name, subject_code, credits, description, created_at, updated_at
	FROM subjects WHERE id = ?`

	var subject models.Subject
	err := r.conn.QueryRowContext(ctx, query, id).Scan(
		&subject.ID, &subject.SubjectName, &subject.SubjectCode, &subject.Credits,
		&subject.Description, &subject.CreatedAt, &subject.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &subject, nil
}

func (r *SubjectRepository) GetAll(ctx context.Context, limit int, offset int) ([]models.Subject, error) {
	query := `SELECT id, subject_name, subject_code, credits, description, created_at, updated_at
	FROM subjects ORDER BY subject_name LIMIT ? OFFSET ?`

	rows, err := r.conn.QueryContext(ctx, query, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var subjects []models.Subject
	for rows.Next() {
		var subject models.Subject
		err := rows.Scan(
			&subject.ID, &subject.SubjectName, &subject.SubjectCode, &subject.Credits,
			&subject.Description, &subject.CreatedAt, &subject.UpdatedAt)
		if err != nil {
			return nil, err
		}
		subjects = append(subjects, subject)
	}

	return subjects, rows.Err()
}

func (r *SubjectRepository) Update(ctx context.Context, subject *models.Subject) error {
	query := `UPDATE subjects SET subject_name = ?, subject_code = ?, credits = ?, description = ?, updated_at = NOW() WHERE id = ?`

	_, err := r.conn.ExecContext(ctx, query,
		subject.SubjectName, subject.SubjectCode, subject.Credits, subject.Description, subject.ID)

	return err
}

func (r *SubjectRepository) Delete(ctx context.Context, id int) error {
	query := `DELETE FROM subjects WHERE id = ?`
	_, err := r.conn.ExecContext(ctx, query, id)
	return err
}

func (r *SubjectRepository) GetByCode(ctx context.Context, code string) (*models.Subject, error) {
	query := `SELECT id, subject_name, subject_code, credits, description, created_at, updated_at
	FROM subjects WHERE subject_code = ?`

	var subject models.Subject
	err := r.conn.QueryRowContext(ctx, query, code).Scan(
		&subject.ID, &subject.SubjectName, &subject.SubjectCode, &subject.Credits,
		&subject.Description, &subject.CreatedAt, &subject.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &subject, nil
}

func (r *SubjectRepository) GetCount(ctx context.Context) (int, error) {
	query := `SELECT COUNT(*) FROM subjects`
	var count int
	err := r.conn.QueryRowContext(ctx, query).Scan(&count)
	return count, err
}

func (r *SubjectRepository) CheckCodeExists(ctx context.Context, code string) (bool, error) {
	query := `SELECT COUNT(*) FROM subjects WHERE subject_code = ?`
	var count int
	err := r.conn.QueryRowContext(ctx, query, code).Scan(&count)
	return count > 0, err
}

func (r *SubjectRepository) Search(ctx context.Context, keyword string) ([]models.Subject, error) {
	query := `SELECT id, subject_name, subject_code, credits, description, created_at, updated_at
	FROM subjects WHERE subject_name LIKE ? OR subject_code LIKE ? ORDER BY subject_name`

	searchTerm := "%" + keyword + "%"
	rows, err := r.conn.QueryContext(ctx, query, searchTerm, searchTerm)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var subjects []models.Subject
	for rows.Next() {
		var subject models.Subject
		err := rows.Scan(
			&subject.ID, &subject.SubjectName, &subject.SubjectCode, &subject.Credits,
			&subject.Description, &subject.CreatedAt, &subject.UpdatedAt)
		if err != nil {
			return nil, err
		}
		subjects = append(subjects, subject)
	}

	return subjects, rows.Err()
}
