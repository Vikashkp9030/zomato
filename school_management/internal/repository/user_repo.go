package repository

import (
	"database/sql"
	"errors"
	"time"

	"school-management/internal/models"
)

type UserRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{db: db}
}

func (r *UserRepository) Create(user *models.User) error {
	query := `INSERT INTO users (email, password, first_name, last_name, role, status, created_at, updated_at)
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?)`

	result, err := r.db.Exec(query, user.Email, user.Password, user.FirstName, user.LastName, user.Role, user.Status, time.Now(), time.Now())
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	user.ID = int(id)
	return nil
}

func (r *UserRepository) GetByEmail(email string) (*models.User, error) {
	query := `SELECT id, email, password, first_name, last_name, role, status, created_at, updated_at
	          FROM users WHERE email = ?`

	user := &models.User{}
	err := r.db.QueryRow(query, email).Scan(
		&user.ID, &user.Email, &user.Password, &user.FirstName,
		&user.LastName, &user.Role, &user.Status, &user.CreatedAt, &user.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	return user, nil
}

func (r *UserRepository) GetByID(id int) (*models.User, error) {
	query := `SELECT id, email, password, first_name, last_name, role, status, created_at, updated_at
	          FROM users WHERE id = ?`

	user := &models.User{}
	err := r.db.QueryRow(query, id).Scan(
		&user.ID, &user.Email, &user.Password, &user.FirstName,
		&user.LastName, &user.Role, &user.Status, &user.CreatedAt, &user.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	return user, nil
}

func (r *UserRepository) Update(user *models.User) error {
	query := `UPDATE users SET email = ?, first_name = ?, last_name = ?, role = ?, status = ?, updated_at = ?
	          WHERE id = ?`

	_, err := r.db.Exec(query, user.Email, user.FirstName, user.LastName, user.Role, user.Status, time.Now(), user.ID)
	return err
}

func (r *UserRepository) UpdatePassword(userID int, hashedPassword string) error {
	query := `UPDATE users SET password = ?, updated_at = ? WHERE id = ?`
	_, err := r.db.Exec(query, hashedPassword, time.Now(), userID)
	return err
}

func (r *UserRepository) Delete(id int) error {
	query := `DELETE FROM users WHERE id = ?`
	_, err := r.db.Exec(query, id)
	return err
}

func (r *UserRepository) List(limit, offset int) ([]*models.User, error) {
	query := `SELECT id, email, password, first_name, last_name, role, status, created_at, updated_at
	          FROM users LIMIT ? OFFSET ?`

	rows, err := r.db.Query(query, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []*models.User
	for rows.Next() {
		user := &models.User{}
		err := rows.Scan(
			&user.ID, &user.Email, &user.Password, &user.FirstName,
			&user.LastName, &user.Role, &user.Status, &user.CreatedAt, &user.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}

	return users, rows.Err()
}

func (r *UserRepository) EmailExists(email string) (bool, error) {
	query := `SELECT COUNT(*) FROM users WHERE email = ?`
	var count int
	err := r.db.QueryRow(query, email).Scan(&count)
	if err != nil {
		return false, err
	}
	return count > 0, nil
}
