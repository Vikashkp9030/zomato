package repository

import (
	"database/sql"
	"errors"
	"time"

	"school-management/internal/models"
)

type FeesRepository struct {
	db *sql.DB
}

func NewFeesRepository(db *sql.DB) *FeesRepository {
	return &FeesRepository{db: db}
}

func (r *FeesRepository) Create(fee *models.Fee) error {
	query := `INSERT INTO fees (student_id, amount, due_date, status, description, created_at, updated_at)
	          VALUES (?, ?, ?, ?, ?, ?, ?)`

	result, err := r.db.Exec(query, fee.StudentID, fee.Amount, fee.DueDate, fee.Status, fee.Description, time.Now(), time.Now())
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	fee.ID = int(id)
	return nil
}

func (r *FeesRepository) GetByID(id int) (*models.Fee, error) {
	query := `SELECT id, student_id, amount, due_date, paid_date, status, description, transaction_id, payment_method, created_at, updated_at
	          FROM fees WHERE id = ?`

	fee := &models.Fee{}
	err := r.db.QueryRow(query, id).Scan(
		&fee.ID, &fee.StudentID, &fee.Amount, &fee.DueDate, &fee.PaidDate, &fee.Status, &fee.Description, &fee.TransactionID, &fee.PaymentMethod, &fee.CreatedAt, &fee.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("fee not found")
		}
		return nil, err
	}

	return fee, nil
}

func (r *FeesRepository) GetByStudentID(studentID int) ([]*models.Fee, error) {
	query := `SELECT id, student_id, amount, due_date, paid_date, status, description, transaction_id, payment_method, created_at, updated_at
	          FROM fees WHERE student_id = ? ORDER BY created_at DESC`

	rows, err := r.db.Query(query, studentID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var fees []*models.Fee
	for rows.Next() {
		fee := &models.Fee{}
		err := rows.Scan(
			&fee.ID, &fee.StudentID, &fee.Amount, &fee.DueDate, &fee.PaidDate, &fee.Status, &fee.Description, &fee.TransactionID, &fee.PaymentMethod, &fee.CreatedAt, &fee.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		fees = append(fees, fee)
	}

	return fees, rows.Err()
}

func (r *FeesRepository) List(limit, offset int, status string) ([]*models.Fee, error) {
	query := `SELECT id, student_id, amount, due_date, paid_date, status, description, transaction_id, payment_method, created_at, updated_at
	          FROM fees`

	var args []interface{}
	if status != "" {
		query += ` WHERE status = ?`
		args = append(args, status)
	}
	query += ` ORDER BY created_at DESC LIMIT ? OFFSET ?`
	args = append(args, limit, offset)

	rows, err := r.db.Query(query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var fees []*models.Fee
	for rows.Next() {
		fee := &models.Fee{}
		err := rows.Scan(
			&fee.ID, &fee.StudentID, &fee.Amount, &fee.DueDate, &fee.PaidDate, &fee.Status, &fee.Description, &fee.TransactionID, &fee.PaymentMethod, &fee.CreatedAt, &fee.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		fees = append(fees, fee)
	}

	return fees, rows.Err()
}

func (r *FeesRepository) Update(fee *models.Fee) error {
	query := `UPDATE fees SET student_id = ?, amount = ?, due_date = ?, paid_date = ?, status = ?, description = ?, transaction_id = ?, payment_method = ?, updated_at = ?
	          WHERE id = ?`

	_, err := r.db.Exec(query, fee.StudentID, fee.Amount, fee.DueDate, fee.PaidDate, fee.Status, fee.Description, fee.TransactionID, fee.PaymentMethod, time.Now(), fee.ID)
	return err
}

func (r *FeesRepository) Delete(id int) error {
	query := `DELETE FROM fees WHERE id = ?`
	_, err := r.db.Exec(query, id)
	return err
}

func (r *FeesRepository) GetStudentFeesSummary(studentID int) (*models.StudentFeesSummary, error) {
	query := `SELECT
		f.student_id,
		s.first_name || ' ' || s.last_name as student_name,
		COALESCE(SUM(f.amount), 0) as total_fees,
		COALESCE(SUM(CASE WHEN f.status = 'paid' THEN f.amount ELSE 0 END), 0) as amount_paid,
		COALESCE(SUM(CASE WHEN f.status != 'paid' THEN f.amount ELSE 0 END), 0) as amount_pending,
		CASE WHEN COALESCE(SUM(CASE WHEN f.status != 'paid' THEN f.amount ELSE 0 END), 0) > 0 THEN 'pending' ELSE 'paid' END as status
	FROM fees f
	LEFT JOIN students s ON f.student_id = s.id
	WHERE f.student_id = ?
	GROUP BY f.student_id, s.first_name, s.last_name`

	summary := &models.StudentFeesSummary{}
	err := r.db.QueryRow(query, studentID).Scan(
		&summary.StudentID, &summary.StudentName, &summary.TotalFees, &summary.AmountPaid, &summary.AmountPending, &summary.Status,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("no fees found for student")
		}
		return nil, err
	}

	return summary, nil
}