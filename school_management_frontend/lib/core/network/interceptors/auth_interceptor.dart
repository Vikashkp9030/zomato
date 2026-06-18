import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../core/services/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final Logger _logger = Logger();
  final LocalStorage _localStorage;

  AuthInterceptor(this._localStorage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _localStorage.getToken();

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      _logger.d('🔐 Auth token added to request');
    }

    _logger.d('📤 [${options.method}] ${options.uri}');
    if (options.data != null) {
      _logger.d('📦 Request Body: ${options.data}');
    }
    _logger.d('🔑 Headers: ${_sanitizeHeaders(options.headers)}');

    return handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    _logger.d(
      '📥 Response [${response.statusCode}] ${response.requestOptions.uri} '
      '(${response.requestOptions.method})',
    );
    _logger.d('📊 Response Body: ${response.data}');

    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    _logger.e(
      '❌ Error [${err.type}] ${err.requestOptions.uri} '
      '(${err.requestOptions.method}): ${err.message}',
    );
    if (err.response != null) {
      _logger.e('📊 Error Response: ${err.response?.data}');
    }

    return handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = 'Bearer [TOKEN]';
    }
    return sanitized;
  }
}
