package database

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

type Database struct {
	conn *sql.DB
}

func New(dsn string) (*Database, error) {
	conn, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}

	if err = conn.Ping(); err != nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	conn.SetMaxOpenConns(25)
	conn.SetMaxIdleConns(5)

	return &Database{conn: conn}, nil
}

func (db *Database) GetConnection() *sql.DB {
	return db.conn
}

func (db *Database) Close() error {
	return db.conn.Close()
}
