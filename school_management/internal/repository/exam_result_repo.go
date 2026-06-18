package repository

import (
	"context"
	"database/sql"
	"school-management/internal/models"
)

type ExamResultRepository struct {
	conn *sql.DB
}

func NewExamResultRepository(conn *sql.DB) *ExamResultRepository {
	return &ExamResultRepository{conn: conn}
}

func (r *ExamResultRepository) Create(ctx context.Context, result *models.ExamResult) (int64, error) {
	query := `INSERT INTO exam_results (exam_id, student_id, marks_obtained, grade, status, attempt)
	VALUES (?, ?, ?, ?, ?, ?)`

	res, err := r.conn.ExecContext(ctx, query,
		result.ExamID, result.StudentID, result.MarksObtained, result.Grade,
		result.Status, result.Attempt)
	if err != nil {
		return 0, err
	}

	return res.LastInsertId()
}

func (r *ExamResultRepository) GetByID(ctx context.Context, id int) (*models.ExamResult, error) {
	query := `SELECT id, exam_id, student_id, marks_obtained, grade, status, attempt, created_at, updated_at
	FROM exam_results WHERE id = ?`

	var result models.ExamResult
	err := r.conn.QueryRowContext(ctx, query, id).Scan(
		&result.ID, &result.ExamID, &result.StudentID, &result.MarksObtained,
		&result.Grade, &result.Status, &result.Attempt, &result.CreatedAt, &result.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &result, nil
}

func (r *ExamResultRepository) GetByExamID(ctx context.Context, examID int, limit int, offset int) ([]models.ExamResult, error) {
	query := `SELECT id, exam_id, student_id, marks_obtained, grade, status, attempt, created_at, updated_at
	FROM exam_results WHERE exam_id = ? ORDER BY marks_obtained DESC LIMIT ? OFFSET ?`

	rows, err := r.conn.QueryContext(ctx, query, examID, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var results []models.ExamResult
	for rows.Next() {
		var result models.ExamResult
		err := rows.Scan(
			&result.ID, &result.ExamID, &result.StudentID, &result.MarksObtained,
			&result.Grade, &result.Status, &result.Attempt, &result.CreatedAt, &result.UpdatedAt)
		if err != nil {
			return nil, err
		}
		results = append(results, result)
	}

	return results, rows.Err()
}

func (r *ExamResultRepository) GetByStudentID(ctx context.Context, studentID int, limit int, offset int) ([]models.ExamResult, error) {
	query := `SELECT id, exam_id, student_id, marks_obtained, grade, status, attempt, created_at, updated_at
	FROM exam_results WHERE student_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?`

	rows, err := r.conn.QueryContext(ctx, query, studentID, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var results []models.ExamResult
	for rows.Next() {
		var result models.ExamResult
		err := rows.Scan(
			&result.ID, &result.ExamID, &result.StudentID, &result.MarksObtained,
			&result.Grade, &result.Status, &result.Attempt, &result.CreatedAt, &result.UpdatedAt)
		if err != nil {
			return nil, err
		}
		results = append(results, result)
	}

	return results, rows.Err()
}

func (r *ExamResultRepository) Update(ctx context.Context, result *models.ExamResult) error {
	query := `UPDATE exam_results SET exam_id = ?, student_id = ?, marks_obtained = ?, grade = ?,
	status = ?, attempt = ?, updated_at = NOW() WHERE id = ?`

	_, err := r.conn.ExecContext(ctx, query,
		result.ExamID, result.StudentID, result.MarksObtained, result.Grade,
		result.Status, result.Attempt, result.ID)

	return err
}

func (r *ExamResultRepository) Delete(ctx context.Context, id int) error {
	query := `DELETE FROM exam_results WHERE id = ?`
	_, err := r.conn.ExecContext(ctx, query, id)
	return err
}

func (r *ExamResultRepository) GetStudentExamResult(ctx context.Context, examID int, studentID int) (*models.ExamResult, error) {
	query := `SELECT id, exam_id, student_id, marks_obtained, grade, status, attempt, created_at, updated_at
	FROM exam_results WHERE exam_id = ? AND student_id = ? LIMIT 1`

	var result models.ExamResult
	err := r.conn.QueryRowContext(ctx, query, examID, studentID).Scan(
		&result.ID, &result.ExamID, &result.StudentID, &result.MarksObtained,
		&result.Grade, &result.Status, &result.Attempt, &result.CreatedAt, &result.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &result, nil
}

func (r *ExamResultRepository) GetExamStats(ctx context.Context, examID int) (map[string]interface{}, error) {
	query := `SELECT
		COUNT(*) as total_results,
		AVG(marks_obtained) as average_marks,
		MAX(marks_obtained) as highest_marks,
		MIN(marks_obtained) as lowest_marks,
		COUNT(CASE WHEN status = 'pass' THEN 1 END) as passed,
		COUNT(CASE WHEN status = 'fail' THEN 1 END) as failed
	FROM exam_results WHERE exam_id = ?`

	var totalResults, passed, failed int
	var averageMarks, highestMarks, lowestMarks sql.NullFloat64

	err := r.conn.QueryRowContext(ctx, query, examID).Scan(
		&totalResults, &averageMarks, &highestMarks, &lowestMarks, &passed, &failed)

	if err != nil {
		return nil, err
	}

	stats := map[string]interface{}{
		"total_results":  totalResults,
		"average_marks":  averageMarks.Float64,
		"highest_marks":  highestMarks.Float64,
		"lowest_marks":   lowestMarks.Float64,
		"passed":         passed,
		"failed":         failed,
		"pass_percentage": float64(passed) / float64(totalResults) * 100,
	}

	return stats, nil
}

func (r *ExamResultRepository) GetStudentGPA(ctx context.Context, studentID int) (float64, error) {
	query := `SELECT AVG(CAST(SUBSTRING(grade, 1, POSITION('.' IN CONCAT(grade, '.')) - 1) AS DECIMAL(3,2)))
	FROM exam_results WHERE student_id = ? AND grade IS NOT NULL`

	var gpa sql.NullFloat64
	err := r.conn.QueryRowContext(ctx, query, studentID).Scan(&gpa)

	if err != nil {
		return 0, err
	}

	if !gpa.Valid {
		return 0, nil
	}

	return gpa.Float64, nil
}

func (r *ExamResultRepository) GetCount(ctx context.Context) (int, error) {
	query := `SELECT COUNT(*) FROM exam_results`
	var count int
	err := r.conn.QueryRowContext(ctx, query).Scan(&count)
	return count, err
}
