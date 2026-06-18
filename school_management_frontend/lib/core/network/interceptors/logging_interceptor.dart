import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger();
  final Map<String, DateTime> _requestStartTimes = {};

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requestId = _generateRequestId();
    options.extra['requestId'] = requestId;
    _requestStartTimes[requestId] = DateTime.now();

    _logger.i(
      '═══════════════════════════════════════════════════════════\n'
      '📡 REQUEST [$requestId]\n'
      '═══════════════════════════════════════════════════════════\n'
      '🔗 URL: ${options.uri}\n'
      '📍 Method: ${options.method}\n'
      '🕐 Time: ${DateTime.now()}\n'
      '${_formatQueryParams(options.queryParameters)}'
      '${_formatHeaders(options.headers)}'
      '${_formatRequestBody(options.data)}'
      '═══════════════════════════════════════════════════════════',
    );

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    final requestId = response.requestOptions.extra['requestId'] as String?;
    final duration = _getRequestDuration(requestId);

    _logger.i(
      '═══════════════════════════════════════════════════════════\n'
      '✅ RESPONSE [$requestId]\n'
      '═══════════════════════════════════════════════════════════\n'
      '🔗 URL: ${response.requestOptions.uri}\n'
      '📊 Status Code: ${response.statusCode}\n'
      '⏱️ Duration: ${duration}ms\n'
      '🕐 Time: ${DateTime.now()}\n'
      '${_formatHeaders(response.headers.map)}'
      '${_formatResponseBody(response.data)}'
      '═══════════════════════════════════════════════════════════',
    );

    if (requestId != null) {
      _requestStartTimes.remove(requestId);
    }

    return handler.next(response);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final requestId = err.requestOptions.extra['requestId'] as String?;
    final duration = _getRequestDuration(requestId);

    _logger.e(
      '═══════════════════════════════════════════════════════════\n'
      '❌ ERROR [$requestId]\n'
      '═══════════════════════════════════════════════════════════\n'
      '🔗 URL: ${err.requestOptions.uri}\n'
      '📍 Method: ${err.requestOptions.method}\n'
      '🚨 Error Type: ${err.type}\n'
      '💬 Message: ${err.message}\n'
      '⏱️ Duration: ${duration}ms\n'
      '🕐 Time: ${DateTime.now()}\n'
      '${err.response != null ? '📊 Status Code: ${err.response?.statusCode}\n' : ''}'
      '${_formatResponseBody(err.response?.data)}'
      '═══════════════════════════════════════════════════════════',
    );

    if (requestId != null) {
      _requestStartTimes.remove(requestId);
    }

    return handler.next(err);
  }

  String _formatHeaders(Map headers) {
    if (headers.isEmpty) return '';

    final sanitized = _sanitizeHeaders(headers);
    final headerString =
        sanitized.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');

    return '📋 Headers:\n$headerString\n';
  }

  String _formatQueryParams(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return '';

    final paramString =
        params.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');

    return '🔍 Query Parameters:\n$paramString\n';
  }

  String _formatRequestBody(dynamic data) {
    if (data == null) return '';

    String bodyString;
    if (data is String) {
      bodyString = data;
    } else if (data is Map) {
      bodyString = _prettyPrintJson(data);
    } else {
      bodyString = data.toString();
    }

    return '📦 Request Body:\n$bodyString\n';
  }

  String _formatResponseBody(dynamic data) {
    if (data == null) return '';

    String bodyString;
    if (data is String) {
      bodyString = data.length > 500 ? '${data.substring(0, 500)}...' : data;
    } else if (data is Map) {
      bodyString = _prettyPrintJson(data);
    } else {
      bodyString = data.toString();
    }

    return '📦 Response Body:\n$bodyString\n';
  }

  Map _sanitizeHeaders(Map headers) {
    final sanitized = Map.from(headers);
    final sensitiveKeys = [
      'Authorization',
      'X-API-Key',
      'Authorization',
      'Cookie'
    ];

    for (final key in sensitiveKeys) {
      if (sanitized.containsKey(key)) {
        sanitized[key] = '[REDACTED]';
      }
    }

    return sanitized;
  }

  String _prettyPrintJson(Map json) {
    try {
      final encoded = json.toString();
      return encoded.length > 500 ? '${encoded.substring(0, 500)}...' : encoded;
    } catch (e) {
      return json.toString();
    }
  }

  String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  String _getRequestDuration(String? requestId) {
    if (requestId == null || !_requestStartTimes.containsKey(requestId)) {
      return 'N/A';
    }

    final startTime = _requestStartTimes[requestId]!;
    final duration = DateTime.now().difference(startTime).inMilliseconds;

    return duration.toString();
  }
}
