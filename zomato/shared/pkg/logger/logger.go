package logger

import (
	"fmt"
	"log/slog"
	"os"
)

type Logger struct {
	*slog.Logger
}

var log *Logger

func Init(env string) {
	var handler slog.Handler

	if env == "production" {
		handler = slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
			Level: slog.LevelInfo,
		})
	} else {
		handler = slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
			Level: slog.LevelDebug,
		})
	}

	log = &Logger{slog.New(handler)}
}

func Get() *Logger {
	if log == nil {
		Init("development")
	}
	return log
}

func (l *Logger) Info(msg string, args ...any) {
	l.Logger.Info(msg, args...)
}

func (l *Logger) Error(msg string, args ...any) {
	l.Logger.Error(msg, args...)
}

func (l *Logger) Warn(msg string, args ...any) {
	l.Logger.Warn(msg, args...)
}

func (l *Logger) Debug(msg string, args ...any) {
	l.Logger.Debug(msg, args...)
}

func (l *Logger) Fatal(msg string, args ...any) {
	l.Logger.Error(msg, args...)
	os.Exit(1)
}

func Info(msg string, args ...any) {
	Get().Info(msg, args...)
}

func Error(msg string, args ...any) {
	Get().Error(msg, args...)
}

func Warn(msg string, args ...any) {
	Get().Warn(msg, args...)
}

func Debug(msg string, args ...any) {
	Get().Debug(msg, args...)
}

func Fatal(msg string, args ...any) {
	Get().Fatal(msg, args...)
}

func Fatalf(format string, args ...any) {
	Get().Fatal(fmt.Sprintf(format, args...))
}
