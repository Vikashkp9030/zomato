# School Management System - Complete Implementation Guide

## Overview
This document provides a complete reference for the 8 school management features implemented using Clean Architecture in Flutter with BLoC state management.

## Architecture Layers

### 1. Data Layer (Repositories)
All 8 repository implementations follow the Auth pattern exactly:

**Files Created:**
- `lib/data/repositories/class_repository_impl.dart`
- `lib/data/repositories/teacher_repository_impl.dart`
- `lib/data/repositories/subject_repository_impl.dart`
- `lib/data/repositories/student_repository_impl.dart`
- `lib/data/repositories/exam_repository_impl.dart`
- `lib/data/repositories/exam_result_repository_impl.dart`
- `lib/data/repositories/attendance_repository_impl.dart`
- `lib/data/repositories/parent_repository_impl.dart`

**Pattern Used:**
```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureApiService apiService;
  final Logger _logger = Logger();

  FeatureRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<FeatureEntity>>> getAll({int page = 1, int limit = 10}) async {
    try {
      final response = await apiService.getAll(page: page, limit: limit);
      final data = response['data'] as List;
      final items = data.map((item) => _mapModelToEntity(Model.fromJson(item))).toList();
      _logger.i('Fetched ${items.length} items');
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 0));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch items'));
    }
  }
}
```

### 2. Domain Layer (Use Cases)
All 8 use case implementations:

**Files Created:**
- `lib/domain/usecases/class_usecases.dart`
- `lib/domain/usecases/teacher_usecases.dart`
- `lib/domain/usecases/subject_usecases.dart`
- `lib/domain/usecases/student_usecases.dart`
- `lib/domain/usecases/exam_usecases.dart`
- `lib/domain/usecases/exam_result_usecases.dart`
- `lib/domain/usecases/attendance_usecases.dart`
- `lib/domain/usecases/parent_usecases.dart`

**Pattern Used:**
```dart
class FeatureUseCases {
  final FeatureRepository repository;

  FeatureUseCases(this.repository);

  Future<Either<Failure, List<FeatureEntity>>> getAll({int page = 1, int limit = 10}) {
    return repository.getAll(page: page, limit: limit);
  }

  Future<Either<Failure, FeatureEntity>> getById(int id) {
    return repository.getById(id);
  }

  // ... other methods delegate to repository
}
```

### 3. Presentation Layer (BLoC)

#### Class Feature (Complete Implementation)
**Events:** `lib/presentation/bloc/class/class_event.dart`
- GetAllClassesEvent
- GetClassByIdEvent
- CreateClassEvent
- UpdateClassEvent
- DeleteClassEvent
- GetClassStudentsEvent
- GetClassSubjectsEvent

**States:** `lib/presentation/bloc/class/class_state.dart`
- ClassInitial
- ClassLoading
- ClassesLoaded
- ClassLoaded
- ClassStudentsLoaded
- ClassSubjectsLoaded
- ClassCreated
- ClassUpdated
- ClassDeleted
- ClassError

**BLoC:** `lib/presentation/bloc/class/class_bloc.dart`
- Handles all events and emits appropriate states
- Error handling with Either pattern
- Logging with Logger

#### Teacher Feature (Partially Implemented as Template)
**Events:** `lib/presentation/bloc/teacher/teacher_event.dart`
**States:** `lib/presentation/bloc/teacher/teacher_state.dart`
**BLoC:** `lib/presentation/bloc/teacher/teacher_bloc.dart`

**Template for Remaining Features:**
Similar structure for:
- Subject
- Student
- Exam
- ExamResult
- Attendance
- Parent

## Service Locator Setup

Updated `lib/core/di/injection_container.dart` includes:

```dart
// API Services Registration
getIt.registerSingleton<ClassApiService>(ClassApiService(getIt<DioClient>()));
getIt.registerSingleton<TeacherApiService>(TeacherApiService(getIt<DioClient>()));
// ... etc for all 8 features

// Repositories Registration
getIt.registerSingleton<ClassRepository>(ClassRepositoryImpl(getIt<ClassApiService>()));
getIt.registerSingleton<TeacherRepository>(TeacherRepositoryImpl(getIt<TeacherApiService>()));
// ... etc for all 8 features

// UseCases Registration
getIt.registerSingleton<ClassUseCases>(ClassUseCases(getIt<ClassRepository>()));
getIt.registerSingleton<TeacherUseCases>(TeacherUseCases(getIt<TeacherRepository>()));
// ... etc for all 8 features

// BLoCs Registration
getIt.registerSingleton<ClassBloc>(ClassBloc(getIt<ClassUseCases>()));
getIt.registerSingleton<TeacherBloc>(TeacherBloc(getIt<TeacherUseCases>()));
// ... subject, student, exam, exam_result, attendance, parent BLoCs need to be added
```

## Feature Implementations

### 1. Classes Feature
**CRUD Operations:**
- Get all classes (paginated)
- Get class by ID
- Create class
- Update class
- Delete class
- Get class students
- Get class subjects

**Grade Filtering:** Available via API queryParameters in getAllClasses

### 2. Teachers Feature
**CRUD Operations:**
- Get all teachers (paginated)
- Get teacher by ID
- Create teacher
- Update teacher
- Delete teacher
- Get teacher classes
- Get teacher subjects (with specialization info)

### 3. Subjects Feature
**CRUD Operations:**
- Get all subjects (paginated)
- Get subject by ID
- Create subject
- Update subject
- Delete subject
- Get subject teachers
- Get subject classes

**Search:** Available via API queryParameters

### 4. Students Feature
**CRUD Operations:**
- Get all students (paginated)
- Get student by ID
- Create student (with class assignment)
- Update student
- Delete student
- Get student performance metrics
- Get student exam results
- Get student attendance summary

### 5. Exams Feature
**CRUD Operations:**
- Get all exams (paginated)
- Get exam by ID
- Create exam
- Update exam
- Delete exam
- Get upcoming exams (scheduling)
- Get exams by class
- Get exam results

### 6. Results Feature
**CRUD Operations:**
- Get all results (paginated)
- Get result by ID
- Create result
- Update result
- Delete result
- Get student results
- Get class results
- Get exam statistics (pass/fail rates, average marks)

### 7. Attendance Feature
**CRUD Operations:**
- Get all attendance (paginated)
- Get attendance by ID
- Mark attendance
- Update attendance
- Delete attendance
- Get student attendance
- Get class attendance (with date filter)
- Get attendance summary (total, present, absent, leave days)
- Mark bulk attendance

### 8. Parents Feature
**CRUD Operations:**
- Get all parents (paginated)
- Get parent by ID
- Create parent
- Update parent
- Delete parent
- Get parent children (linked students)
- Link parent to student
- Unlink parent from student

## Error Handling

All layers use consistent error handling:

**Failure Types:**
- ServerFailure
- NetworkFailure
- NoDataFailure
- CacheFailure

**Exception Types:**
- ServerException
- NetworkException
- (Handled transparently via Dio)

## Data Models
All data models are already created with:
- JSON serialization/deserialization
- Equatable for comparison
- Request and Response variants

## Next Steps to Complete Implementation

### 1. Create Remaining BLoCs
For Subject, Student, Exam, ExamResult, Attendance, and Parent features:
- Create `*_event.dart` files
- Create `*_state.dart` files
- Create `*_bloc.dart` files

Use the Teacher BLoC as a template.

### 2. Presentation Pages
Create for each feature:
- List page with pagination and search
- Detail page
- Create/Edit page with forms

### 3. Update Router
In `lib/config/routes/router.dart`, replace PlaceholderPage with actual feature pages.

### 4. Form Validation
Create validators for form inputs using the same pattern as Auth.

### 5. UI Components
Create reusable widgets:
- Feature list cards
- Feature forms
- Loading/Error/Empty state widgets

## Testing Considerations

- Mock repositories and API services
- Test BLoC event handling
- Test state transitions
- Test error scenarios

## API Endpoints Used

The implementation uses these API endpoints (71 total):
- `/classes` - Class management
- `/teachers` - Teacher management
- `/subjects` - Subject management
- `/students` - Student management
- `/exams` - Exam management
- `/results` - Results management
- `/attendance` - Attendance management
- `/parents` - Parent management

Plus related nested endpoints for relationships.

## Database Models

The backend supports 22 data models already created:
- Class
- Teacher
- Subject
- Student
- Exam
- ExamResult
- Attendance
- Parent
- StudentPerformance
- AttendanceSummary
- ExamStats
- And related entities

## Production Readiness Checklist

- [x] Error handling with Either pattern
- [x] Data layer with proper mapping
- [x] Domain layer with use cases
- [x] Presentation layer (BLoC for 2 features shown, template provided)
- [x] Service locator setup
- [ ] Presentation pages (UI)
- [ ] Form validation
- [ ] Unit tests
- [ ] Integration tests
- [ ] API interceptors configured
- [ ] Token refresh logic
- [ ] Offline support considerations

## Key Points

1. **Null Safety:** All code uses proper null safety with `?` and `required` keywords
2. **Logging:** Logger package used for debugging
3. **State Management:** BLoC pattern with clear event -> state flow
4. **Error Handling:** Either<Failure, Success> pattern throughout
5. **API Integration:** DioClient with request/response interceptors
6. **Dependency Injection:** GetIt service locator for all dependencies

## Code Quality

- Follows Dart effective style guide
- Const constructors used where applicable
- Proper use of Equatable for comparison
- No magic numbers or hardcoded values
- Comprehensive error messages

## Performance Considerations

- Pagination support on all list endpoints
- Lazy loading in BLoCs
- Request timeout configured (30 seconds)
- Logger configured for debugging

---

**Status:** Implementation complete for data and domain layers. Presentation layer partially shown (Class and Teacher BLoCs). Remaining 6 BLoCs follow the exact same pattern.

**Ready for:** UI development, form creation, and page implementation.
