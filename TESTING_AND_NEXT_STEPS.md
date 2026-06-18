# Testing & Implementation Guide - School Management System

**Date:** June 17, 2026  
**Status:** ✅ 3 Modules Complete | 🔄 6 Modules Ready for Implementation

---

## 🧪 TESTING THE COMPLETED MODULES

### Prerequisites
1. Backend database running (PostgreSQL or SQLite)
2. Backend API server running on `http://localhost:8080`
3. Frontend Flutter app running on iOS/Android/Web

### Backend Setup & Testing

#### 1. Build the Backend
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
go build -o school-mgmt ./cmd
./school-mgmt
```

Expected output: Server should start on port 8080

#### 2. Test Dashboard Endpoints
```bash
# Get Dashboard Stats
curl -X GET http://localhost:8080/api/v1/dashboard/stats \
  -H "Authorization: Bearer YOUR_TOKEN"

# Response should include:
# {
#   "success": true,
#   "message": "Dashboard stats retrieved successfully",
#   "data": {
#     "total_students": 150,
#     "total_teachers": 20,
#     "total_classes": 12,
#     "average_attendance": 85.5,
#     "pending_fees": 15000.00,
#     "upcoming_exams": 8,
#     "total_subjects": 12,
#     "active_hostels": 2
#   }
# }
```

#### 3. Test Fees Endpoints

```bash
# List all fees
curl -X GET "http://localhost:8080/api/v1/fees?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Create a new fee
curl -X POST http://localhost:8080/api/v1/fees \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "student_id": 1,
    "amount": 5000,
    "due_date": "2026-06-30T00:00:00Z",
    "description": "Monthly tuition fee"
  }'

# Get fee details
curl -X GET http://localhost:8080/api/v1/fees/1 \
  -H "Authorization: Bearer YOUR_TOKEN"

# Pay a fee
curl -X POST http://localhost:8080/api/v1/fees/1/pay \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "payment_method": "card",
    "transaction_id": "TXN123456"
  }'

# Get receipt
curl -X GET http://localhost:8080/api/v1/fees/1/receipt \
  -H "Authorization: Bearer YOUR_TOKEN"

# Get student fees
curl -X GET http://localhost:8080/api/v1/students/1/fees \
  -H "Authorization: Bearer YOUR_TOKEN"

# Get fee summary
curl -X GET http://localhost:8080/api/v1/students/1/fees/summary \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Frontend Testing

#### 1. Run the Flutter App
```bash
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend
flutter pub get
flutter run
```

#### 2. Test Dashboard Screen
- Navigate to Dashboard page
- Verify statistics cards load (students, teachers, classes, exams)
- Verify attendance chart renders
- Verify class performance data displays
- Verify upcoming exams list shows
- Verify pending fees summary displays
- Verify notifications feed shows
- Click refresh button and verify data updates
- Test error state by disconnecting network

#### 3. Test Fees Screen
- Navigate to Fees page
- Verify fees list loads with pagination
- Test status filters (pending, paid, overdue)
- Click on a fee to view details
- Test payment flow (click "Pay Now")
- Test receipt viewing (if fee is paid)
- Test creating new fee (click FAB)
- Test error handling

---

## 🚀 IMPLEMENTING REMAINING MODULES (6 modules)

All remaining modules follow the exact same pattern. Here's the step-by-step guide:

### Module Template Overview
1. **Backend**: Handler (10 min) → Routes (2 min)
2. **Frontend**: Domain (5 min) → Data (5 min) → Presentation (10 min) → UI (10 min)
3. **Dependency Injection**: (2 min)

**Total per module: ~45 minutes**

---

## 📋 STEP-BY-STEP IMPLEMENTATION

### BACKEND IMPLEMENTATION (12 minutes per module)

#### Step 1: Create Backend Handler (10 minutes)

Example structure for Timetable module:

```go
// internal/handler/timetable_handler.go
package handler

import (
    "encoding/json"
    "net/http"
    "strconv"
    "school-management/internal/models"
    "school-management/internal/repository"
    "school-management/internal/utils"
)

type TimetableHandler struct {
    timetableRepo *repository.TimetableRepository
    classRepo     *repository.ClassRepository
}

func NewTimetableHandler(
    timetableRepo *repository.TimetableRepository,
    classRepo *repository.ClassRepository,
) *TimetableHandler {
    return &TimetableHandler{
        timetableRepo: timetableRepo,
        classRepo:     classRepo,
    }
}

// Implement handler methods:
// - List (GET /timetable)
// - GetByID (GET /timetable/{id})
// - Create (POST /timetable)
// - Update (PUT /timetable/{id})
// - Delete (DELETE /timetable/{id})
// - GetByClass (GET /classes/{class_id}/timetable)
```

Copy from: `internal/handler/fees_handler.go` (good reference)

#### Step 2: Create Repository (optional, if needed)

If you need to query the database directly, create a repository:

```go
// internal/repository/timetable_repo.go
package repository

import (
    "database/sql"
    "school-management/internal/models"
)

type TimetableRepository struct {
    db *sql.DB
}

func NewTimetableRepository(db *sql.DB) *TimetableRepository {
    return &TimetableRepository{db: db}
}

// Implement methods: Create, GetByID, List, Update, Delete, GetByClassID
```

Copy from: `internal/repository/fees_repo.go` (good reference)

#### Step 3: Register in Routes (2 minutes)

In `internal/routes/routes.go`:

```go
// Add to RegisterRoutes function:
timetableRepo := repository.NewTimetableRepository(conn)
timetableHandler := handler.NewTimetableHandler(timetableRepo, classRepo)

// Add routes after fees routes:
protected.HandleFunc("/timetable", timetableHandler.List).Methods("GET")
protected.HandleFunc("/timetable", timetableHandler.Create).Methods("POST")
protected.HandleFunc("/timetable/{id}", timetableHandler.GetByID).Methods("GET")
protected.HandleFunc("/timetable/{id}", timetableHandler.Update).Methods("PUT")
protected.HandleFunc("/timetable/{id}", timetableHandler.Delete).Methods("DELETE")
protected.HandleFunc("/classes/{class_id}/timetable", timetableHandler.GetByClass).Methods("GET")
```

---

### FRONTEND IMPLEMENTATION (32 minutes per module)

#### Step 1: Domain Layer (5 minutes)

Create two files following the Fees module pattern:

```dart
// lib/features/timetable/domain/repositories/timetable_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class TimetableRepository {
  Future<Either<Failure, List<dynamic>>> getAllTimetables({int page, int limit});
  Future<Either<Failure, Map<String, dynamic>>> getTimetableById(String id);
  Future<Either<Failure, List<dynamic>>> getClassTimetable(String classId);
  Future<Either<Failure, Map<String, dynamic>>> createTimetable(Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> updateTimetable(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteTimetable(String id);
}

// lib/features/timetable/domain/usecases/timetable_usecases.dart
import 'package:dartz/dartz.dart';
import '../repositories/timetable_repository.dart';
import '../../../../core/error/failures.dart';

class TimetableUseCases {
  final TimetableRepository repository;

  TimetableUseCases(this.repository);

  // Implement methods matching the repository interface
}
```

Copy from: `lib/features/fees/domain/` (good reference)

#### Step 2: Data Layer (5 minutes)

```dart
// lib/features/timetable/data/repositories/timetable_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../datasources/timetable_api_service.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  final TimetableApiService apiService;

  TimetableRepositoryImpl(this.apiService);

  // Implement methods with error handling
  // Pattern: try-catch, return Either<Failure, Data>
}
```

Copy from: `lib/features/fees/data/repositories/fees_repository_impl.dart` (good reference)

#### Step 3: Presentation Layer (10 minutes)

```dart
// lib/features/timetable/presentation/bloc/timetable_event.dart
abstract class TimetableEvent extends Equatable {
  // Create events: FetchTimetablesEvent, CreateTimetableEvent, etc.
}

// lib/features/timetable/presentation/bloc/timetable_state.dart
abstract class TimetableState extends Equatable {
  // Create states: TimetableLoadedState, TimetableErrorState, etc.
}

// lib/features/timetable/presentation/bloc/timetable_bloc.dart
class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final TimetableUseCases useCases;

  TimetableBloc(this.useCases) : super(const TimetableInitialState()) {
    // Register event handlers
  }

  // Implement event handlers
}
```

Copy from: `lib/features/fees/presentation/bloc/` (good reference)

#### Step 4: UI Screens (10 minutes)

```dart
// lib/features/timetable/presentation/pages/timetable_page.dart
class TimetablePage extends StatefulWidget {
  // Build page with BlocProvider, BlocBuilder
  // Display list of timetables
  // Add create/edit dialogs
  // Handle errors with retry button
}
```

Copy from: `lib/features/fees/presentation/pages/fees_page.dart` (good reference)

#### Step 5: Register in Dependency Injection (2 minutes)

In `lib/injection_container.dart`:

```dart
// Add imports
import 'features/timetable/data/datasources/timetable_api_service.dart';
import 'features/timetable/domain/repositories/timetable_repository.dart';
import 'features/timetable/domain/usecases/timetable_usecases.dart';
import 'features/timetable/presentation/bloc/timetable_bloc.dart';

// In setupServiceLocator():
getIt.registerSingleton<TimetableRepository>(
  TimetableRepositoryImpl(getIt<TimetableApiService>()),
);
getIt.registerSingleton<TimetableUseCases>(
  TimetableUseCases(getIt<TimetableRepository>()),
);
getIt.registerSingleton<TimetableBloc>(
  TimetableBloc(getIt<TimetableUseCases>()),
);
```

---

## 📊 MODULES TO IMPLEMENT (6 remaining)

### 1. **Timetable Module**
- Endpoints: GET/POST timetable, GET timetable by ID, GET class timetable
- Features: View timetable, create schedule, view by class
- Estimated time: 45 min

### 2. **Transport Module**
- Endpoints: GET/POST transport, manage routes, view schedules
- Features: Vehicle management, route tracking, student mapping
- Estimated time: 45 min

### 3. **Hostel Module**
- Endpoints: GET/POST hostel, manage rooms, assign students
- Features: Room management, student allocation, complaint tracking
- Estimated time: 45 min

### 4. **Library Module**
- Endpoints: GET/POST books, manage issue/return, search
- Features: Book catalog, borrowing, return, search
- Estimated time: 45 min

### 5. **Notifications Module**
- Endpoints: GET notifications, POST notification, mark as read
- Features: Push notifications, notification history, filters
- Estimated time: 45 min

### 6. **Payroll Module**
- Endpoints: GET/POST salary, generate payroll, view deductions
- Features: Salary management, payroll generation, reports
- Estimated time: 45 min

---

## 🔄 IMPLEMENTATION WORKFLOW

### For Each Module:

1. **Backend (12 min)**
   - Copy handler from fees_handler.go as template
   - Create repository if needed (copy from fees_repo.go)
   - Register in routes.go
   - Test with curl commands

2. **Frontend Domain (5 min)**
   - Copy repository interface from fees_repository.dart
   - Copy use cases from fees_usecases.dart
   - Update method names to match your module

3. **Frontend Data (5 min)**
   - Copy implementation from fees_repository_impl.dart
   - Update API service calls

4. **Frontend Presentation (10 min)**
   - Copy events from fees_event.dart
   - Copy states from fees_state.dart
   - Copy BLoC from fees_bloc.dart
   - Update method implementations

5. **Frontend UI (10 min)**
   - Copy page from fees_page.dart
   - Update UI elements to match module
   - Test in emulator/device

6. **Dependency Injection (2 min)**
   - Add registrations to injection_container.dart

---

## ✅ CHECKLIST FOR EACH MODULE

- [ ] Backend handler created
- [ ] Backend repository created (if needed)
- [ ] Routes registered
- [ ] Backend compiles successfully
- [ ] Frontend domain layer created
- [ ] Frontend data layer created
- [ ] Frontend presentation layer created
- [ ] Frontend UI page created
- [ ] Dependency injection registered
- [ ] Flutter analyze passes
- [ ] Manual testing completed
- [ ] Error handling verified

---

## 🎯 QUICK REFERENCE: FILE LOCATIONS

### Backend
- Models: `internal/models/[module].go`
- Repositories: `internal/repository/[module]_repo.go`
- Handlers: `internal/handler/[module]_handler.go`
- Routes: `internal/routes/routes.go`

### Frontend
- API Service: `lib/features/[module]/data/datasources/[module]_api_service.dart`
- Repository Interface: `lib/features/[module]/domain/repositories/[module]_repository.dart`
- Use Cases: `lib/features/[module]/domain/usecases/[module]_usecases.dart`
- Repository Impl: `lib/features/[module]/data/repositories/[module]_repository_impl.dart`
- Events: `lib/features/[module]/presentation/bloc/[module]_event.dart`
- States: `lib/features/[module]/presentation/bloc/[module]_state.dart`
- BLoC: `lib/features/[module]/presentation/bloc/[module]_bloc.dart`
- Page: `lib/features/[module]/presentation/pages/[module]_page.dart`

### Dependency Injection
- File: `lib/injection_container.dart`
- Add imports and registrations for API service, repository, use cases, and BLoC

---

## 📈 COMPLETION TIMELINE

- **Phase 1**: 9 modules (✅ COMPLETE)
- **Phase 2 Current**: 3 modules (Dashboard, Fees) (✅ COMPLETE)
- **Phase 2 Remaining**: 6 modules (🔄 READY)

**Estimated time to complete all 6 remaining modules: 4-5 hours**

At 45 minutes per module with the templates and references available, you can complete the entire system in one focused session.

---

## 💡 TIPS FOR RAPID IMPLEMENTATION

1. **Use Find & Replace**: When copying a module template, use find & replace to change all module names
2. **Copy Existing Patterns**: Always copy from Fees module (most complete reference)
3. **Follow Structure**: Maintain the same folder structure and file naming
4. **Test Early**: Test API endpoints before implementing UI
5. **Error Handling**: Copy error handling patterns from Fees module
6. **Reuse Widgets**: Use existing widgets from Dashboard/Fees for UI

---

## 🚀 READY TO START?

All models and API services are already created. Pick any of the 6 remaining modules and follow the 45-minute workflow above. The most similar module to Fees is Timetable, so start there for easiest implementation.

**Happy coding!** 🎉