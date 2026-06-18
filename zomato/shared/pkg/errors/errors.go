package errors

import (
	"fmt"
	"net/http"
)

type ErrorCode string

const (
	ErrValidation      ErrorCode = "VALIDATION_ERROR"
	ErrUnauthorized    ErrorCode = "UNAUTHORIZED"
	ErrForbidden       ErrorCode = "FORBIDDEN"
	ErrNotFound        ErrorCode = "NOT_FOUND"
	ErrConflict        ErrorCode = "CONFLICT"
	ErrInternal        ErrorCode = "INTERNAL_ERROR"
	ErrBadRequest      ErrorCode = "BAD_REQUEST"
	ErrInvalidToken    ErrorCode = "INVALID_TOKEN"
	ErrTokenExpired    ErrorCode = "TOKEN_EXPIRED"
	ErrPaymentFailed   ErrorCode = "PAYMENT_FAILED"
	ErrOrderNotFound   ErrorCode = "ORDER_NOT_FOUND"
	ErrRestaurantNotFound ErrorCode = "RESTAURANT_NOT_FOUND"
	ErrUserNotFound    ErrorCode = "USER_NOT_FOUND"
	ErrDuplicate       ErrorCode = "DUPLICATE_ENTRY"
	ErrServiceUnavailable ErrorCode = "SERVICE_UNAVAILABLE"
)

type CustomError struct {
	Code       ErrorCode
	Message    string
	StatusCode int
	Details    map[string]interface{}
}

func (e *CustomError) Error() string {
	return e.Message
}

func (e *CustomError) GetStatusCode() int {
	return e.StatusCode
}

func (e *CustomError) GetCode() ErrorCode {
	return e.Code
}

func NewValidationError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrValidation,
		Message:    msg,
		StatusCode: http.StatusBadRequest,
	}
}

func NewUnauthorizedError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrUnauthorized,
		Message:    msg,
		StatusCode: http.StatusUnauthorized,
	}
}

func NewForbiddenError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrForbidden,
		Message:    msg,
		StatusCode: http.StatusForbidden,
	}
}

func NewNotFoundError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrNotFound,
		Message:    msg,
		StatusCode: http.StatusNotFound,
	}
}

func NewConflictError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrConflict,
		Message:    msg,
		StatusCode: http.StatusConflict,
	}
}

func NewInternalError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrInternal,
		Message:    msg,
		StatusCode: http.StatusInternalServerError,
	}
}

func NewPaymentError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrPaymentFailed,
		Message:    msg,
		StatusCode: http.StatusPaymentRequired,
	}
}

func NewServiceUnavailableError(msg string) *CustomError {
	return &CustomError{
		Code:       ErrServiceUnavailable,
		Message:    msg,
		StatusCode: http.StatusServiceUnavailable,
	}
}

func NewCustomError(code ErrorCode, msg string, statusCode int) *CustomError {
	return &CustomError{
		Code:       code,
		Message:    msg,
		StatusCode: statusCode,
	}
}

func (e *CustomError) WithDetails(key string, value interface{}) *CustomError {
	if e.Details == nil {
		e.Details = make(map[string]interface{})
	}
	e.Details[key] = value
	return e
}

func IsCustomError(err error) (*CustomError, bool) {
	ce, ok := err.(*CustomError)
	return ce, ok
}

func GetStatusCode(err error) int {
	if ce, ok := IsCustomError(err); ok {
		return ce.StatusCode
	}
	return http.StatusInternalServerError
}

func GetErrorCode(err error) ErrorCode {
	if ce, ok := IsCustomError(err); ok {
		return ce.Code
	}
	return ErrInternal
}

func Wrap(err error, msg string) error {
	return fmt.Errorf("%s: %w", msg, err)
}
