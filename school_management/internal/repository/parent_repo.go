package repository

import (
	"context"
	"database/sql"
	"school-management/internal/models"
)

type ParentRepository struct {
	conn *sql.DB
}

func NewParentRepository(conn *sql.DB) *ParentRepository {
	return &ParentRepository{conn: conn}
}

func (r *ParentRepository) Create(ctx context.Context, parent *models.Parent) (int64, error) {
	query := `INSERT INTO parents (student_id, parent_name, relationship, phone, email, occupation)
	VALUES (?, ?, ?, ?, ?, ?)`

	result, err := r.conn.ExecContext(ctx, query,
		parent.StudentID, parent.ParentName, parent.Relationship,
		parent.Phone, parent.Email, parent.Occupation)
	if err != nil {
		return 0, err
	}

	return result.LastInsertId()
}

func (r *ParentRepository) GetByID(ctx context.Context, id int) (*models.Parent, error) {
	query := `SELECT id, student_id, parent_name, relationship, phone, email, occupation, created_at, updated_at
	FROM parents WHERE id = ?`

	var parent models.Parent
	err := r.conn.QueryRowContext(ctx, query, id).Scan(
		&parent.ID, &parent.StudentID, &parent.ParentName, &parent.Relationship,
		&parent.Phone, &parent.Email, &parent.Occupation, &parent.CreatedAt, &parent.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &parent, nil
}

func (r *ParentRepository) GetByStudentID(ctx context.Context, studentID int) ([]models.Parent, error) {
	query := `SELECT id, student_id, parent_name, relationship, phone, email, occupation, created_at, updated_at
	FROM parents WHERE student_id = ? ORDER BY relationship`

	rows, err := r.conn.QueryContext(ctx, query, studentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var parents []models.Parent
	for rows.Next() {
		var parent models.Parent
		err := rows.Scan(
			&parent.ID, &parent.StudentID, &parent.ParentName, &parent.Relationship,
			&parent.Phone, &parent.Email, &parent.Occupation, &parent.CreatedAt, &parent.UpdatedAt)
		if err != nil {
			return nil, err
		}
		parents = append(parents, parent)
	}

	return parents, rows.Err()
}

func (r *ParentRepository) GetAll(ctx context.Context, limit int, offset int) ([]models.Parent, error) {
	query := `SELECT id, student_id, parent_name, relationship, phone, email, occupation, created_at, updated_at
	FROM parents ORDER BY parent_name LIMIT ? OFFSET ?`

	rows, err := r.conn.QueryContext(ctx, query, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var parents []models.Parent
	for rows.Next() {
		var parent models.Parent
		err := rows.Scan(
			&parent.ID, &parent.StudentID, &parent.ParentName, &parent.Relationship,
			&parent.Phone, &parent.Email, &parent.Occupation, &parent.CreatedAt, &parent.UpdatedAt)
		if err != nil {
			return nil, err
		}
		parents = append(parents, parent)
	}

	return parents, rows.Err()
}

func (r *ParentRepository) Update(ctx context.Context, parent *models.Parent) error {
	query := `UPDATE parents SET student_id = ?, parent_name = ?, relationship = ?, phone = ?,
	email = ?, occupation = ?, updated_at = NOW() WHERE id = ?`

	_, err := r.conn.ExecContext(ctx, query,
		parent.StudentID, parent.ParentName, parent.Relationship,
		parent.Phone, parent.Email, parent.Occupation, parent.ID)

	return err
}

func (r *ParentRepository) Delete(ctx context.Context, id int) error {
	query := `DELETE FROM parents WHERE id = ?`
	_, err := r.conn.ExecContext(ctx, query, id)
	return err
}

func (r *ParentRepository) GetByEmail(ctx context.Context, email string) ([]models.Parent, error) {
	query := `SELECT id, student_id, parent_name, relationship, phone, email, occupation, created_at, updated_at
	FROM parents WHERE email = ?`

	rows, err := r.conn.QueryContext(ctx, query, email)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var parents []models.Parent
	for rows.Next() {
		var parent models.Parent
		err := rows.Scan(
			&parent.ID, &parent.StudentID, &parent.ParentName, &parent.Relationship,
			&parent.Phone, &parent.Email, &parent.Occupation, &parent.CreatedAt, &parent.UpdatedAt)
		if err != nil {
			return nil, err
		}
		parents = append(parents, parent)
	}

	return parents, rows.Err()
}

func (r *ParentRepository) GetByPhone(ctx context.Context, phone string) ([]models.Parent, error) {
	query := `SELECT id, student_id, parent_name, relationship, phone, email, occupation, created_at, updated_at
	FROM parents WHERE phone = ?`

	rows, err := r.conn.QueryContext(ctx, query, phone)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var parents []models.Parent
	for rows.Next() {
		var parent models.Parent
		err := rows.Scan(
			&parent.ID, &parent.StudentID, &parent.ParentName, &parent.Relationship,
			&parent.Phone, &parent.Email, &parent.Occupation, &parent.CreatedAt, &parent.UpdatedAt)
		if err != nil {
			return nil, err
		}
		parents = append(parents, parent)
	}

	return parents, rows.Err()
}

func (r *ParentRepository) GetCount(ctx context.Context) (int, error) {
	query := `SELECT COUNT(*) FROM parents`
	var count int
	err := r.conn.QueryRowContext(ctx, query).Scan(&count)
	return count, err
}

func (r *ParentRepository) GetStudentParentCount(ctx context.Context, studentID int) (int, error) {
	query := `SELECT COUNT(*) FROM parents WHERE student_id = ?`
	var count int
	err := r.conn.QueryRowContext(ctx, query, studentID).Scan(&count)
	return count, err
}
