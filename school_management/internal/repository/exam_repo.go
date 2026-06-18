package repository

import (
	"database/sql"
	"errors"
	"time"

	"school-management/internal/models"
)

type ExamRepository struct {
	db *sql.DB
}

func NewExamRepository(db *sql.DB) *ExamRepository {
	return &ExamRepository{db: db}
}

func (r *ExamRepository) Create(exam *models.Exam) error {
	query := `INSERT INTO exams (exam_name, exam_type, exam_date, exam_time, total_marks, passing_marks, subject_id, class_id, created_at, updated_at)
	          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`

	result, err := r.db.Exec(query, exam.ExamName, exam.ExamType, exam.ExamDate, exam.ExamTime, exam.TotalMarks, exam.PassingMarks, exam.SubjectID, exam.ClassID, time.Now(), time.Now())
	if err != nil {
		return err
	}

	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	exam.ID = int(id)
	return nil
}

func (r *ExamRepository) GetByID(id int) (*models.Exam, error) {
	query := `SELECT id, exam_name, exam_type, exam_date, exam_time, total_marks, passing_marks, subject_id, class_id, created_at, updated_at
	          FROM exams WHERE id = ?`

	exam := &models.Exam{}
	err := r.db.QueryRow(query, id).Scan(
		&exam.ID, &exam.ExamName, &exam.ExamType, &exam.ExamDate, &exam.ExamTime, &exam.TotalMarks, &exam.PassingMarks, &exam.SubjectID, &exam.ClassID, &exam.CreatedAt, &exam.UpdatedAt,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("exam not found")
		}
		return nil, err
	}

	return exam, nil
}

func (r *ExamRepository) GetByClassID(classID int) ([]*models.Exam, error) {
	query := `SELECT id, exam_name, exam_type, exam_date, exam_time, total_marks, passing_marks, subject_id, class_id, created_at, updated_at
	          FROM exams WHERE class_id = ? ORDER BY exam_date DESC`

	rows, err := r.db.Query(query, classID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var exams []*models.Exam
	for rows.Next() {
		exam := &models.Exam{}
		err := rows.Scan(
			&exam.ID, &exam.ExamName, &exam.ExamType, &exam.ExamDate, &exam.ExamTime, &exam.TotalMarks, &exam.PassingMarks, &exam.SubjectID, &exam.ClassID, &exam.CreatedAt, &exam.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		exams = append(exams, exam)
	}

	return exams, rows.Err()
}

func (r *ExamRepository) List(limit, offset int) ([]*models.Exam, error) {
	query := `SELECT id, exam_name, exam_type, exam_date, exam_time, total_marks, passing_marks, subject_id, class_id, created_at, updated_at
	          FROM exams ORDER BY exam_date DESC LIMIT ? OFFSET ?`

	rows, err := r.db.Query(query, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var exams []*models.Exam
	for rows.Next() {
		exam := &models.Exam{}
		err := rows.Scan(
			&exam.ID, &exam.ExamName, &exam.ExamType, &exam.ExamDate, &exam.ExamTime, &exam.TotalMarks, &exam.PassingMarks, &exam.SubjectID, &exam.ClassID, &exam.CreatedAt, &exam.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		exams = append(exams, exam)
	}

	return exams, rows.Err()
}

func (r *ExamRepository) Update(exam *models.Exam) error {
	query := `UPDATE exams SET exam_name = ?, exam_type = ?, exam_date = ?, exam_time = ?, total_marks = ?, passing_marks = ?, subject_id = ?, class_id = ?, updated_at = ?
	          WHERE id = ?`

	_, err := r.db.Exec(query, exam.ExamName, exam.ExamType, exam.ExamDate, exam.ExamTime, exam.TotalMarks, exam.PassingMarks, exam.SubjectID, exam.ClassID, time.Now(), exam.ID)
	return err
}

func (r *ExamRepository) Delete(id int) error {
	query := `DELETE FROM exams WHERE id = ?`
	_, err := r.db.Exec(query, id)
	return err
}
