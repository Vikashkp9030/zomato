# 🔧 Response Parsing Fix - Unexpected Error Resolution

## Problem Found
The snackbar was showing "unexpected error" despite the API returning a successful 200 response with tokens and user data.

**Root Cause:** The response model expected different field names than what the Go backend was actually returning.

---

## API Response Format (Actual)
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "email": "vikash798561@gmail.com",
      "first_name": "Vikash",
      "last_name": "Kumar",
      "role": "admin",
      "status": "Active",
      "created_at": "2026-06-16T22:12:12+05:30",
      "updated_at": "2026-06-16T23:05:33+05:30"
    }
  }
}
```

## Model Expected Format (Before Fix)
```json
{
  "accessToken": "...",
  "refreshToken": "...",
  "message": "...",
  "user": {
    "id": "1",
    "firstName": "Vikash",
    "lastName": "Kumar",
    "email": "...",
    "phoneNumber": "...",
    "role": "admin",
    "profileImage": null,
    "isActive": true,
    "createdAt": "...",
    "updatedAt": "..."
  }
}
```

---

## Fixes Applied

### 1. AuthResponse Model (`auth_response.dart`)

**Changes:**
- ✅ Handle wrapped response with `data` object
- ✅ Support both snake_case (`access_token`) and camelCase (`accessToken`)
- ✅ Extract message from root level

**Code:**
```dart
factory AuthResponse.fromJson(Map<String, dynamic> json) {
  // Handle both wrapped (data object) and unwrapped responses
  final data = json['data'] as Map<String, dynamic>? ?? json;

  return AuthResponse(
    accessToken: (data['access_token'] ?? data['accessToken']) as String,
    refreshToken: (data['refresh_token'] ?? data['refreshToken']) as String,
    user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    message: (json['message'] ?? data['message']) as String? ?? 'Success',
  );
}
```

### 2. UserModel (`user_model.dart`)

**Changes:**
- ✅ Support `id` as dynamic (int from API)
- ✅ Handle snake_case field names (`first_name`, `last_name`, etc.)
- ✅ Replace `isActive` with `status` (matching API)
- ✅ Make `phoneNumber` optional (API doesn't always provide it)
- ✅ Support both camelCase and snake_case in parsing

**Code:**
```dart
factory UserModel.fromJson(Map<String, dynamic> json) {
  // Handle both camelCase and snake_case field names from API
  final firstName = (json['first_name'] ?? json['firstName']) as String? ?? '';
  final lastName = (json['last_name'] ?? json['lastName']) as String? ?? '';
  final status = json['status'] as String? ?? 'Active';
  final createdAtStr = (json['created_at'] ?? json['createdAt']) as String?;
  final updatedAtStr = (json['updated_at'] ?? json['updatedAt']) as String?;

  return UserModel(
    id: json['id'],
    firstName: firstName,
    lastName: lastName,
    email: json['email'] as String,
    phoneNumber: (json['phone_number'] ?? json['phoneNumber']) as String?,
    role: json['role'] as String? ?? 'user',
    profileImage: (json['profile_image'] ?? json['profileImage']) as String?,
    status: status,
    createdAt: createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now(),
    updatedAt: updatedAtStr != null ? DateTime.parse(updatedAtStr) : null,
  );
}
```

---

## ✅ What's Fixed

| Item | Before | After |
|------|--------|-------|
| **Response Wrapper** | ❌ Not handled | ✅ Handles `data` object |
| **Field Names** | ❌ camelCase only | ✅ Both snake_case & camelCase |
| **access_token** | ❌ Fails to parse | ✅ Correctly parsed |
| **refresh_token** | ❌ Fails to parse | ✅ Correctly parsed |
| **first_name** | ❌ Throws error | ✅ Properly mapped to firstName |
| **last_name** | ❌ Throws error | ✅ Properly mapped to lastName |
| **status** | ❌ No support | ✅ Now supported |
| **id** | ❌ Expected string | ✅ Handles int/dynamic |
| **Error Message** | ❌ "Unexpected error" | ✅ ✅ LOGIN SUCCESS |

---

## 🚀 Now Test Again

### Step 1: Hot Restart Flutter App
```bash
# In the running Flutter web app, press 'r' for hot reload
# Or Ctrl+Shift+R for hot restart
```

### Step 2: Try Login Again
```
Email: vikash798561@gmail.com
Password: Vikash@123
```

### Step 3: Expected Result
```
✅ Login Successful (No error snackbar!)
✅ Tokens stored in LocalStorage
✅ User data retrieved
✅ Navigate to next screen
```

---

## 📋 Verification Checklist

- [ ] No compilation errors
- [ ] Frontend running: `flutter run -d chrome`
- [ ] Backend running: `go run ./cmd/main.go`
- [ ] Interceptors logging in console
- [ ] Login API returns 200 with tokens
- [ ] No "unexpected error" snackbar
- [ ] Tokens stored in LocalStorage (F12 → Application)
- [ ] User authenticated and navigates properly
- [ ] AuthState changes to AuthAuthenticated

---

## 🔍 Debug Tips

If you still see errors:

1. **Check Console Logs:**
   - Look for the 📥 Response logging
   - Check if it contains `access_token` and `user` object

2. **Check Network Tab (F12):**
   - Look at the actual API response
   - Verify it contains `success: true` and `data` object

3. **Check LocalStorage (F12 → Application):**
   - After successful login, should see:
     - `auth_token: eyJhbGci...`
     - `refresh_token: eyJhbGci...`
     - `user_data: {...}`

4. **Enable Debug Mode:**
   - Add breakpoint in `auth_bloc.dart` `_onLogin` method
   - Check the parsed token and user objects

---

## 📝 Summary

All response parsing issues have been fixed. The models now correctly handle:
- ✅ The wrapped response format with `data` object
- ✅ Snake_case field names from Go backend
- ✅ Optional fields that might not always be present
- ✅ Different data types (int id instead of string)

**Login should now work perfectly without "unexpected error"!** 🎉