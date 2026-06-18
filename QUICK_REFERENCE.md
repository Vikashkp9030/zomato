# Quick Reference Guide - School Management System

## 🚀 Quick Start Commands

### Run Backend
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
go run cmd/main.go
```

### Run Frontend
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend
flutter pub get
flutter run
```

---

## 📁 Key File Locations

### Backend
```
school_management/
├── cmd/main.go                          # Entry point
├── internal/
│   ├── handler/                         # HTTP handlers
│   │   ├── auth_handler.go
│   │   ├── student_handler.go
│   │   ├── teacher_handler.go
│   │   ├── class_handler.go
│   │   ├── exam_handler.go
│   │   ├── exam_result_handler.go
│   │   ├── subject_handler.go
│   │   ├── attendance_handler.go
│   │   ├── parent_handler.go
│   │   └── dashboard_handler.go         # NEW
│   ├── repository/                      # Data access
│   ├── models/                          # Data models
│   │   ├── school.go
│   │   ├── user.go
│   │   ├── dashboard.go                 # NEW
│   │   ├── timetable.go                 # NEW
│   │   ├── fees.go                      # NEW
│   │   └── ... (other Phase 2 models)
│   ├── middleware/                      # Auth, CORS, Logging
│   ├── database/                        # DB connection
│   └── routes/routes.go                 # Route registration

config/config.go                         # Configuration
```

### Frontend
```
school_management_frontend/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   ├── dio_client.dart
│   │   │   └── interceptors/
│   │   └── services/
│   │       ├── app_config.dart
│   │       └── local_storage.dart
│   ├── features/
│   │   ├── authentication/
│   │   ├── classes/
│   │   ├── teachers/
│   │   ├── students/
│   │   ├── subjects/
│   │   ├── exams/
│   │   ├── exam_results/
│   │   ├── parents/
│   │   ├── attendance/
│   │   ├── dashboard/               # NEW
│   │   ├── timetable/               # NEW
│   │   ├── fees/                    # NEW
│   │   ├── transport/               # NEW
│   │   ├── hostel/                  # NEW
│   │   ├── library/                 # NEW
│   │   ├── notifications/           # NEW
│   │   ├── payroll/                 # NEW
│   │   └── reports/                 # NEW
│   └── injection_container.dart     # DI setup
├── pubspec.yaml                     # Dependencies
└── android/, ios/, web/             # Platform-specific
```

---

## 🔄 API Endpoints

### Base URL
```
http://localhost:8080/api/v1
```

### Authentication (No Auth Required)
```
POST /auth/register          # Register new user
POST /auth/login             # Login
POST /auth/refresh           # Refresh token
```

### Core Modules (Auth Required)
```
GET/POST /classes            # Class CRUD
GET/POST /teachers           # Teacher CRUD
GET/POST /subjects           # Subject CRUD
GET/POST /students           # Student CRUD
GET/POST /exams              # Exam CRUD
GET/POST /exam-results       # Exam result CRUD
GET/POST /attendance         # Attendance CRUD
GET/POST /parents            # Parent CRUD
```

### Phase 2 Modules (To Be Implemented)
```
GET /dashboard/stats         # Dashboard statistics
GET /timetable               # Class timetables
GET/POST /fees               # Fee management
GET/POST /transport          # Transport routes
GET/POST /hostel             # Hostel management
GET/POST /library/books      # Library books
GET/POST /notifications      # Notifications
GET/POST /payroll            # Payroll
GET /reports/*               # Reports
```

---

## 💻 Common Development Tasks

### Add a New Phase 2 Module

1. **Create domain layer:**
```dart
// lib/features/{module}/domain/repositories/{module}_repository.dart
abstract class {Module}Repository {
  Future<Either<Failure, {ReturnType}>> method1();
}

// lib/features/{module}/domain/usecases/{module}_usecases.dart
class {Module}UseCases {
  final {Module}Repository repository;
  // ... methods
}
```

2. **Create repository implementation:**
```dart
// lib/features/{module}/data/repositories/{module}_repository_impl.dart
class {Module}RepositoryImpl implements {Module}Repository {
  final {Module}ApiService apiService;
  // ... implement methods using apiService
}
```

3. **Create BLoC:**
```dart
// Events
abstract class {Module}Event extends Equatable {}

// States
abstract class {Module}State extends Equatable {}

// BLoC
class {Module}Bloc extends Bloc<{Module}Event, {Module}State> {
  final {Module}UseCases useCases;
  // ... handle events
}
```

4. **Update injection container:**
```dart
// In setupServiceLocator()
getIt.registerSingleton<{Module}Repository>(
  {Module}RepositoryImpl(getIt<{Module}ApiService>()),
);
getIt.registerSingleton<{Module}UseCases>(
  {Module}UseCases(getIt<{Module}Repository>()),
);
getIt.registerSingleton<{Module}Bloc>(
  {Module}Bloc(getIt<{Module}UseCases>()),
);
```

5. **Create UI screen:**
```dart
// lib/features/{module}/presentation/pages/{module}_page.dart
class {Module}Page extends StatefulWidget {
  @override
  State<{Module}Page> createState() => _{Module}PageState();
}

class _{Module}PageState extends State<{Module}Page> {
  @override
  void initState() {
    context.read<{Module}Bloc>().add(const FetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{Module}Bloc, {Module}State>(
      builder: (context, state) {
        if (state is LoadingState) return LoadingWidget();
        if (state is ErrorState) return ErrorWidget();
        if (state is LoadedState) return ContentWidget();
        return SizedBox.shrink();
      },
    );
  }
}
```

---

## 🧪 Testing

### Run Flutter Tests
```bash
flutter test
```

### Run Backend Tests
```bash
go test ./...
```

### Build APK
```bash
flutter build apk --release
```

### Build Web
```bash
flutter build web
```

---

## 🔍 Debugging

### Enable Logging
All requests and responses are logged via Logger package.

### Check API Response
The dio_client includes logging interceptors that show:
- Request method and URL
- Request headers and body
- Response status and body
- Error details

### Common Issues

| Issue | Solution |
|-------|----------|
| 401 Unauthorized | Token expired, use refresh endpoint |
| 404 Not Found | Check endpoint URL and method |
| 500 Server Error | Check backend logs |
| CORS Error | Check CORS middleware in backend |
| Type Error | Check model serialization in fromJson |
| BLoC not updating | Check emit() calls in BLoC |

---

## 📊 Database Schema Reference

### Core Tables (Phase 1)
```
users               # Registered users
classes             # Class information
teachers            # Teacher details
students            # Student enrollment
subjects            # Subject catalog
exams               # Exam schedules
exam_results        # Student exam results
attendance          # Attendance records
parents             # Parent/Guardian info
```

### Phase 2 Tables (To Be Created)
```
timetables          # Class schedules
fees                # Fee records
fee_payments        # Payment tracking
transport           # Transport assignments
transport_routes    # Bus routes
hostels             # Hostel information
hostel_allocations  # Room assignments
library_books       # Book catalog
book_issues         # Book borrowing
notifications       # User notifications
payroll             # Salary records
reports             # Generated reports
```

---

## 🔑 Authentication

### Login Flow
```
1. POST /auth/login (email, password)
2. Get access_token & refresh_token
3. Store tokens in LocalStorage
4. Include access_token in Authorization header
5. When expired, POST /auth/refresh
6. Get new access_token
```

### Token Storage
```dart
// Saved in SharedPreferences
'access_token': 'eyJhbGciOiJIUzI1NiI...'
'refresh_token': 'eyJhbGciOiJIUzI1NiI...'
'user_data': '{...}'
```

---

## 📦 Dependencies

### Backend (Go)
```
github.com/gorilla/mux       # HTTP router
github.com/lib/pq            # PostgreSQL driver
github.com/golang-jwt/jwt    # JWT handling
```

### Frontend (Flutter)
```
flutter_bloc             # State management
dio                      # HTTP client
dartz                    # Either/Or pattern
logger                   # Logging
get_it                   # Dependency injection
shared_preferences       # Local storage
equatable                # Value equality
```

---

## 🚀 Performance Tips

1. **Use BlocBuilder** only for widgets that need updates
2. **Implement caching** in repositories for frequently accessed data
3. **Paginate API responses** for large datasets
4. **Use const constructors** for better performance
5. **Lazy load** images and lists
6. **Implement search** with debounce for API calls
7. **Use database indexes** on frequently queried columns

---

## 📝 Naming Conventions

### Files
```
{feature}_page.dart          # Screens
{feature}_bloc.dart          # BLoC
{feature}_event.dart         # Events
{feature}_state.dart         # States
{feature}_api_service.dart   # API services
{feature}_repository.dart    # Repository interface
{feature}_repository_impl.dart # Implementation
{feature}_usecases.dart      # Use cases
{feature}_model.dart         # Data models
{feature}_entity.dart        # Domain entities
```

### Classes
```
{Feature}Bloc               # BLoC classes
{Feature}Event              # Event classes
{Feature}State              # State classes
{Feature}ApiService         # API service
{Feature}Repository         # Repository interface
{Feature}RepositoryImpl      # Implementation
{Feature}UseCases           # Use cases
{Feature}Model              # Model classes
{Feature}Entity             # Entity classes
```

---

## 🔐 Security Checklist

- ✅ JWT authentication enabled
- ✅ CORS middleware configured
- ✅ Secure token storage (SharedPreferences)
- ✅ HTTPS ready (configure in production)
- ✅ Input validation on API calls
- ✅ Error messages don't expose sensitive data
- ✅ Database credentials in environment variables

---

## 📞 Support Resources

1. **API_IMPLEMENTATION_STATUS.md** - Detailed status and endpoints
2. **PHASE2_IMPLEMENTATION_GUIDE.md** - Step-by-step implementation guide
3. **IMPLEMENTATION_SUMMARY.md** - Complete project overview
4. **Code Examples** - Dashboard handler and repository provided

---

## ✅ Verification Checklist

Before committing:
- [ ] No compile errors
- [ ] No type warnings
- [ ] All imports are correct
- [ ] Dependencies registered in DI
- [ ] Proper error handling
- [ ] Logging statements present
- [ ] Comments for complex logic
- [ ] Follow naming conventions
- [ ] Const constructors used
- [ ] No unused imports

---

**Last Updated:** June 17, 2026  
**Project Status:** ✅ Phase 1 Complete | 🔄 Phase 2 Ready