import 'dart:convert';
import 'package:http/http.dart' as http;

// Android emulator  : http://10.0.2.2:8080/api
// iOS simulator     : http://localhost:8080/api
// Flutter web       : http://localhost:8080/api
// Physical device   : http://<YOUR_LOCAL_IP>:8080/api
const String kBaseUrl = 'http://localhost:8080/api';

class ApiCallResponse {
  ApiCallResponse(this.jsonBody, this.statusCode, {this.response});

  final dynamic jsonBody;
  final int statusCode;
  final http.Response? response;

  bool get succeeded => statusCode >= 200 && statusCode < 300;
  String get bodyText => response?.body ?? '';
  String? get errorMessage => jsonBody?['error'] as String?;

  static ApiCallResponse fromResponse(http.Response res) {
    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (_) {
      body = res.body;
    }
    return ApiCallResponse(body, res.statusCode, response: res);
  }
}

Map<String, String> _authHeaders(String token) => {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

const _jsonHeaders = {'Content-Type': 'application/json'};

// ─── Auth ─────────────────────────────────────────────────────────────────

class LoginCall {
  static Future<ApiCallResponse> call({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$kBaseUrl/auth/login'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return ApiCallResponse.fromResponse(res);
  }

  static String? token(ApiCallResponse r) =>
      r.jsonBody?['data']?['token'] as String?;
  static dynamic user(ApiCallResponse r) => r.jsonBody?['data']?['user'];
}

class SignupCall {
  static Future<ApiCallResponse> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$kBaseUrl/auth/signup'),
      headers: _jsonHeaders,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return ApiCallResponse.fromResponse(res);
  }

  static String? token(ApiCallResponse r) =>
      r.jsonBody?['data']?['token'] as String?;
  static dynamic user(ApiCallResponse r) => r.jsonBody?['data']?['user'];
}

// ─── Todos ────────────────────────────────────────────────────────────────

class ListTodosCall {
  static Future<ApiCallResponse> call({
    required String token,
    int page = 1,
    int limit = 50,
    String? completed,
    String? priority,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'limit': '$limit',
      if (completed != null) 'completed': completed,
      if (priority != null) 'priority': priority,
    };
    final uri = Uri.parse('$kBaseUrl/todos').replace(queryParameters: params);
    final res = await http.get(uri, headers: _authHeaders(token));
    return ApiCallResponse.fromResponse(res);
  }

  static List<dynamic> todos(ApiCallResponse r) {
    final list = r.jsonBody?['data']?['todos'];
    return list is List ? list : [];
  }
}

class CreateTodoCall {
  static Future<ApiCallResponse> call({
    required String token,
    required String title,
    String description = '',
    String priority = 'medium',
    String? dueDate,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
    };
    final res = await http.post(
      Uri.parse('$kBaseUrl/todos'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    return ApiCallResponse.fromResponse(res);
  }
}

class UpdateTodoCall {
  static Future<ApiCallResponse> call({
    required String token,
    required int id,
    String? title,
    String? description,
    bool? completed,
    String? priority,
    String? dueDate,
  }) async {
    final body = <String, dynamic>{
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (completed != null) 'completed': completed,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
    };
    final res = await http.put(
      Uri.parse('$kBaseUrl/todos/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    return ApiCallResponse.fromResponse(res);
  }
}

class DeleteTodoCall {
  static Future<ApiCallResponse> call({
    required String token,
    required int id,
  }) async {
    final res = await http.delete(
      Uri.parse('$kBaseUrl/todos/$id'),
      headers: _authHeaders(token),
    );
    return ApiCallResponse.fromResponse(res);
  }
}

class ToggleTodoCall {
  static Future<ApiCallResponse> call({
    required String token,
    required int id,
  }) async {
    final res = await http.patch(
      Uri.parse('$kBaseUrl/todos/$id/toggle'),
      headers: _authHeaders(token),
    );
    return ApiCallResponse.fromResponse(res);
  }
}
