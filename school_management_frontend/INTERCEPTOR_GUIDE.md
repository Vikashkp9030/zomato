# 🔧 Complete API Interceptors Implementation Guide

## Overview
A comprehensive interceptor system has been implemented for the School Management Frontend. This system handles authentication, error handling, and detailed request/response logging.

---

## ✅ What Was Implemented

### 1. **Enhanced Auth Interceptor** (`auth_interceptor.dart`)
- Automatically adds Bearer token to all requests
- Adds proper Content-Type and Accept headers
- Logs request/response details with emojis for easy console reading
- Sanitizes sensitive headers (hides actual tokens in logs)

**Features:**
- ✅ Automatic token injection from LocalStorage
- ✅ Proper header management
- ✅ Request body logging
- ✅ Response body logging
- ✅ Secure header sanitization

**Example Log Output:**
```
📤 [POST] http://localhost:8080/api/v1/auth/login
📦 Request Body: {email: user@example.com, password: ****}
🔑 Headers: {Content-Type: application/json, Authorization: Bearer [TOKEN]}
```

### 2. **Comprehensive Error Interceptor** (`error_interceptor.dart`)
- Handles all types of DioException errors
- Provides user-friendly error messages
- Logs detailed error information with status codes
- Differentiates between timeout, network, and server errors

**Supported Error Types:**
- ⏱️ Connection Timeout
- 📤 Send Timeout
- 📥 Receive Timeout
- ❌ Bad Response (400, 401, 403, 404, 409, 422, 500, 502, 503)
- 🚫 Request Cancelled
- ❓ Unknown Errors

**Example Log Output:**
```
🚨 [badResponse] http://localhost:8080/api/v1/auth/login
   Status: 401
   Message: 🔐 Unauthorized. Please login again.
   Details: Server responded with status code: 401
📋 Server Response: {message: Invalid credentials, code: AUTH_001}
```

### 3. **Advanced Logging Interceptor** (`logging_interceptor.dart`)
- Logs complete request/response details with timestamps
- Includes request duration timing
- Pretty-prints JSON bodies
- Generates unique request IDs for tracking
- Formats headers and query parameters for easy reading
- Automatically truncates large responses (>500 chars)

**Logged Information:**
- Request ID (unique timestamp-based identifier)
- Full URL and HTTP method
- Query parameters (if any)
- Request headers
- Request body (formatted JSON)
- Response status code
- Response duration in milliseconds
- Response headers
- Response body
- Error details (if applicable)

**Example Log Output:**
```
═══════════════════════════════════════════════════════════
📡 REQUEST [1687920456789]
═══════════════════════════════════════════════════════════
🔗 URL: http://localhost:8080/api/v1/auth/login
📍 Method: POST
🕐 Time: 2024-06-17 15:30:45.123
📋 Headers:
  Content-Type: application/json
  Authorization: Bearer [TOKEN]
📦 Request Body: {email: user@example.com, password: ****}
═══════════════════════════════════════════════════════════

═══════════════════════════════════════════════════════════
✅ RESPONSE [1687920456789]
═══════════════════════════════════════════════════════════
🔗 URL: http://localhost:8080/api/v1/auth/login
📊 Status Code: 200
⏱️ Duration: 234ms
🕐 Time: 2024-06-17 15:30:45.357
📋 Headers:
  content-type: application/json
  server: golang/1.21
📦 Response Body: {token: eyJhbG..., refreshToken: abc123..., user: {...}}
═══════════════════════════════════════════════════════════
```

---

## 🏗️ Architecture

### Interceptor Chain (Order Matters)
```
Request Flow:
  Client Request
        ↓
   LoggingInterceptor (logs all details)
        ↓
   AuthInterceptor (adds auth token)
        ↓
   ErrorInterceptor (catches errors)
        ↓
   Dio HTTP Client
        ↓
   ErrorInterceptor (handles response errors)
        ↓
   AuthInterceptor (logs response)
        ↓
   LoggingInterceptor (logs final response)
        ↓
   Response to Client
```

### File Structure
```
lib/core/network/
├── dio_client.dart                 (Main HTTP client wrapper)
├── interceptors/
│   ├── auth_interceptor.dart       (Authentication & headers)
│   ├── error_interceptor.dart      (Error handling)
│   └── logging_interceptor.dart    (Request/response logging)
```

### Dependency Injection Setup
```dart
// In injection_container.dart
// LocalStorage is initialized FIRST
final localStorage = LocalStorage();
await localStorage.init();

// Then DioClient is created with LocalStorage
final dioClient = DioClient(dio, localStorage);
```

---

## 🔑 Key Features

### 1. **Authentication Token Management**
```dart
// Tokens are automatically:
// - Retrieved from LocalStorage
// - Added to Authorization header as "Bearer <token>"
// - Sanitized in logs (shown as [TOKEN])
```

### 2. **Comprehensive Error Handling**
```dart
// Each error type is handled specifically:
// - Timeout errors: Suggest checking internet
// - Auth errors (401): Prompt user to login again
// - Validation errors (422): Show validation messages
// - Server errors (500): Show generic error message
```

### 3. **Request/Response Logging**
```dart
// All logged with:
// - Request/Response ID for correlation
// - Timestamps for debugging
// - Duration timing for performance analysis
// - Headers and body (with sensitive data masked)
```

### 4. **Performance Monitoring**
```dart
// Each request logs:
// - Start time
// - End time
// - Total duration in milliseconds
// Use this to identify slow requests
```

---

## 💻 Usage Examples

### Making a Login Request
```dart
final authApiService = getIt<AuthApiService>();
final response = await authApiService.login(
  LoginRequest(
    email: 'user@example.com',
    password: 'password123',
  ),
);
// Console will show:
// ✅ Complete request details
// ✅ Authentication headers added
// ✅ Response with duration
// ✅ Any errors with proper messages
```

### Making a Protected Request
```dart
final classApiService = getIt<ClassApiService>();
final classes = await classApiService.getAllClasses();
// Token is automatically added from localStorage
// Console will show:
// 📤 [GET] http://localhost:8080/api/v1/classes
// 🔐 Auth token added to request
// ✅ RESPONSE [200] Duration: 123ms
```

### Handling Errors
```dart
try {
  final response = await authApiService.login(request);
} on DioException catch (e) {
  // Error is logged with:
  // ❌ Error type (timeout, badResponse, etc.)
  // ❌ Status code if applicable
  // ❌ User-friendly message
  // ❌ Server response details
}
```

---

## 📊 Console Output Examples

### Successful Login Flow
```
═══════════════════════════════════════════════════════════
📡 REQUEST [1687920456789]
═══════════════════════════════════════════════════════════
🔗 URL: http://localhost:8080/api/v1/auth/login
📍 Method: POST
📦 Request Body: {email: vikash798561@gmail.com}
═══════════════════════════════════════════════════════════

✅ RESPONSE [1687920456789]
✅ Status Code: 200
⏱️ Duration: 234ms
📦 Response Body: {token: abc123..., user: {id: 1, name: Vikash}}
```

### Failed Login (401 Unauthorized)
```
═══════════════════════════════════════════════════════════
❌ ERROR [badResponse]
═══════════════════════════════════════════════════════════
🔗 URL: http://localhost:8080/api/v1/auth/login
🚨 Error Type: badResponse
📊 Status Code: 401
💬 Message: 🔐 Unauthorized. Please login again.
⏱️ Duration: 150ms
📋 Server Response: {message: Invalid credentials, code: AUTH_001}
═══════════════════════════════════════════════════════════
```

### Network Timeout
```
═══════════════════════════════════════════════════════════
❌ ERROR [receiveTimeout]
═══════════════════════════════════════════════════════════
🔗 URL: http://localhost:8080/api/v1/classes
🚨 Error Type: receiveTimeout
💬 Message: 📥 Receive timeout. Please try again.
⏱️ Duration: 30000ms
═══════════════════════════════════════════════════════════
```

---

## 🔒 Security Features

### 1. **Token Sanitization**
- Actual tokens are never printed in logs
- Shown as `[TOKEN]` in headers
- Passwords are masked in request bodies

### 2. **Sensitive Headers Protection**
- Authorization headers are redacted
- X-API-Key headers are redacted
- Cookie headers are redacted

### 3. **Secure Storage**
- Tokens are stored in SharedPreferences (encrypted on device)
- Tokens are automatically retrieved from secure storage
- Tokens are cleared on logout

---

## 🛠️ Configuration

### Timeouts
Located in `injection_container.dart`:
```dart
BaseOptions(
  baseUrl: AppConfig.baseUrl,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
)
```

### Base URL
Configured in `app_config.dart`:
```dart
_baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080/api/v1'
```

---

## 📈 Monitoring & Debugging

### Finding Requests by ID
All requests have unique IDs in logs. Search for `[1687920456789]` to find all related logs.

### Performance Analysis
Check `⏱️ Duration: XXXms` to identify slow requests.

### Error Tracking
Search for `❌ ERROR` to find all failed requests.

### Token Issues
Search for `🔐 Auth token` to verify tokens are being added.

---

## 🐛 Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| 401 Unauthorized | No token in storage | Ensure user is logged in |
| Token shown as `null` | LocalStorage not initialized | Token initialization happens in setup |
| Timeouts on all requests | Slow network/server | Check server status and network |
| CORS errors | Browser/frontend config issue | Check server CORS settings |
| Headers missing | Interceptor not added | Verify interceptor order in DioClient |

---

## 📝 Next Steps

1. **Run the app**: `flutter run`
2. **Check console**: Look for logging output when making requests
3. **Monitor errors**: Watch for error messages in the console
4. **Test login**: Verify auth token is added to requests
5. **Test failures**: Try invalid credentials to see error handling

---

## 📚 Related Files
- `lib/core/network/dio_client.dart` - Main HTTP client
- `lib/core/services/local_storage.dart` - Token storage
- `lib/injection_container.dart` - Dependency injection setup
- `lib/core/services/app_config.dart` - Configuration

---

## ✨ Summary

✅ **Auth Interceptor**: Handles authentication tokens and headers  
✅ **Error Interceptor**: Provides user-friendly error messages  
✅ **Logging Interceptor**: Logs all request/response details with timing  
✅ **Security**: Masks sensitive data in logs  
✅ **Debugging**: Unique request IDs and detailed timing information  
✅ **Performance**: Request duration tracking for optimization  

All API calls now have complete visibility with detailed logging, proper error handling, and automatic authentication!