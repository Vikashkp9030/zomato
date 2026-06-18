import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  final Logger _logger = Logger();

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final errorInfo = _getErrorInfo(err);

    _logger.e(
      '🚨 [${err.type.toString()}] ${err.requestOptions.uri}\n'
      '   Status: ${err.response?.statusCode ?? "N/A"}\n'
      '   Message: ${errorInfo['message']}\n'
      '   Details: ${errorInfo['details']}',
    );

    if (err.response?.data != null) {
      _logger.e('📋 Server Response: ${err.response?.data}');
    }

    return handler.next(err);
  }

  Map<String, String> _getErrorInfo(DioException error) {
    String message = _getErrorMessage(error);
    String details = _getErrorDetails(error);

    return {
      'message': message,
      'details': details,
    };
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '⏱️ Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return '📤 Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return '📥 Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return '🚫 Request was cancelled.';
      case DioExceptionType.unknown:
        return '❓ An unexpected error occurred.';
      default:
        return '⚠️ An error occurred. Please try again.';
    }
  }

  String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? 500;
    final responseData = error.response?.data;

    String message = responseData?['message'] ?? 'An error occurred';
    if (responseData is Map && responseData.containsKey('error')) {
      message = responseData['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return '❌ Bad Request: $message';
      case 401:
        return '🔐 Unauthorized. Please login again.';
      case 403:
        return '🚫 Access Forbidden: You do not have permission.';
      case 404:
        return '🔍 Resource Not Found.';
      case 409:
        return '⚡ Conflict: Resource already exists.';
      case 422:
        return '✋ Validation Error: $message';
      case 500:
        return '🔴 Server Error. Please try again later.';
      case 502:
        return '🔴 Bad Gateway. Please try again later.';
      case 503:
        return '🔴 Service Unavailable. Please try again later.';
      default:
        return '⚠️ Error ($statusCode): $message';
    }
  }

  String _getErrorDetails(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection took too long to establish.';
      case DioExceptionType.sendTimeout:
        return 'Request data took too long to send.';
      case DioExceptionType.receiveTimeout:
        return 'Response data took too long to receive.';
      case DioExceptionType.badResponse:
        return 'Server responded with status code: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled by the user.';
      case DioExceptionType.unknown:
        return error.message ?? 'Unknown error occurred';
      default:
        return 'Unknown error type';
    }
  }
}
