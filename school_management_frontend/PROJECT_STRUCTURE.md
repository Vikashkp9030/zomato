# School Management Flutter App - Project Structure

## Overview
This is a production-ready Flutter application for managing school operations with clean architecture, BLoC state management, and GoRouter navigation.

## Project Folder Structure

```
school_management_frontend/
├── lib/
│   ├── main.dart                              # App entry point
│   ├── config/
│   │   ├── app_config.dart                   # App configuration (env vars)
│   │   ├── routes/
│   │   │   └── router.dart                   # GoRouter configuration
│   │   └── theme/
│   │       └── app_theme.dart                # Theme definitions
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart            # App-wide constants
│   │   ├── di/
│   │   │   └── injection_container.dart      # Service locator setup
│   │   ├── errors/
│   │   │   ├── exceptions.dart               # Custom exceptions
│   │   │   └── failures.dart                 # Failure definitions
│   │   ├── observers/
│   │   │   └── bloc_observer.dart            # BLoC observer for logging
│   │   └── utils/
│   │       ├── app_extensions.dart           # Useful extensions
│   │       ├── app_utils.dart                # Utility functions
│   │       └── validators.dart               # Input validators
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── remote/
│   │   │   │   ├── dio_client.dart           # Dio HTTP client
│   │   │   │   ├── api_services/
│   │   │   │   │   ├── auth_api_service.dart
│   │   │   │   │   ├── class_api_service.dart
│   │   │   │   │   ├── teacher_api_service.dart
│   │   │   │   │   ├── subject_api_service.dart
│   │   │   │   │   ├── student_api_service.dart
│   │   │   │   │   ├── exam_api_service.dart
│   │   │   │   │   ├── exam_result_api_service.dart
│   │   │   │   │   ├── attendance_api_service.dart
│   │   │   │   │   └── parent_api_service.dart
│   │   │   │   └── interceptors/
│   │   │   │       ├── auth_interceptor.dart
│   │   │   │       └── error_interceptor.dart
│   │   │   └── local/
│   │   │       ├── local_storage.dart        # Shared preferences wrapper
│   │   │       ├── hive_models/
│   │   │       │   └── user_model.dart       # Hive user model
│   │   │       └── hive_service.dart         # Hive database service
│   │   ├── models/
│   │   │   ├── auth/
│   │   │   │   ├── login_request.dart
│   │   │   │   ├── register_request.dart
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_response.dart
│   │   │   ├── class/
│   │   │   │   ├── class_model.dart
│   │   │   │   ├── class_request.dart
│   │   │   │   └── class_info_model.dart
│   │   │   ├── teacher/
│   │   │   │   ├── teacher_model.dart
│   │   │   │   └── teacher_request.dart
│   │   │   ├── subject/
│   │   │   │   ├── subject_model.dart
│   │   │   │   └── subject_request.dart
│   │   │   ├── student/
│   │   │   │   ├── student_model.dart
│   │   │   │   └── student_request.dart
│   │   │   ├── exam/
│   │   │   │   ├── exam_model.dart
│   │   │   │   └── exam_request.dart
│   │   │   ├── exam_result/
│   │   │   │   ├── exam_result_model.dart
│   │   │   │   ├── exam_result_request.dart
│   │   │   │   └── exam_stats_model.dart
│   │   │   ├── attendance/
│   │   │   │   ├── attendance_model.dart
│   │   │   │   ├── attendance_request.dart
│   │   │   │   └── attendance_summary_model.dart
│   │   │   └── parent/
│   │   │       ├── parent_model.dart
│   │   │       └── parent_request.dart
│   │   └── repositories/
│   │       ├── auth_repository_impl.dart
│   │       ├── class_repository_impl.dart
│   │       ├── teacher_repository_impl.dart
│   │       ├── subject_repository_impl.dart
│   │       ├── student_repository_impl.dart
│   │       ├── exam_repository_impl.dart
│   │       ├── exam_result_repository_impl.dart
│   │       ├── attendance_repository_impl.dart
│   │       └── parent_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── auth_entity.dart
│   │   │   ├── class_entity.dart
│   │   │   ├── teacher_entity.dart
│   │   │   ├── subject_entity.dart
│   │   │   ├── student_entity.dart
│   │   │   ├── exam_entity.dart
│   │   │   ├── exam_result_entity.dart
│   │   │   ├── attendance_entity.dart
│   │   │   └── parent_entity.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── class_repository.dart
│   │   │   ├── teacher_repository.dart
│   │   │   ├── subject_repository.dart
│   │   │   ├── student_repository.dart
│   │   │   ├── exam_repository.dart
│   │   │   ├── exam_result_repository.dart
│   │   │   ├── attendance_repository.dart
│   │   │   └── parent_repository.dart
│   │   └── usecases/
│   │       ├── auth_usecases.dart
│   │       ├── class_usecases.dart
│   │       ├── teacher_usecases.dart
│   │       ├── subject_usecases.dart
│   │       ├── student_usecases.dart
│   │       ├── exam_usecases.dart
│   │       ├── exam_result_usecases.dart
│   │       ├── attendance_usecases.dart
│   │       └── parent_usecases.dart
│   ├── presentation/
│   │   ├── bloc/
│   │   │   ├── auth/
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   ├── class/
│   │   │   │   ├── class_bloc.dart
│   │   │   │   ├── class_event.dart
│   │   │   │   └── class_state.dart
│   │   │   ├── teacher/
│   │   │   │   ├── teacher_bloc.dart
│   │   │   │   ├── teacher_event.dart
│   │   │   │   └── teacher_state.dart
│   │   │   ├── subject/
│   │   │   │   ├── subject_bloc.dart
│   │   │   │   ├── subject_event.dart
│   │   │   │   └── subject_state.dart
│   │   │   ├── student/
│   │   │   │   ├── student_bloc.dart
│   │   │   │   ├── student_event.dart
│   │   │   │   └── student_state.dart
│   │   │   ├── exam/
│   │   │   │   ├── exam_bloc.dart
│   │   │   │   ├── exam_event.dart
│   │   │   │   └── exam_state.dart
│   │   │   ├── exam_result/
│   │   │   │   ├── exam_result_bloc.dart
│   │   │   │   ├── exam_result_event.dart
│   │   │   │   └── exam_result_state.dart
│   │   │   ├── attendance/
│   │   │   │   ├── attendance_bloc.dart
│   │   │   │   ├── attendance_event.dart
│   │   │   │   └── attendance_state.dart
│   │   │   └── parent/
│   │   │       ├── parent_bloc.dart
│   │   │       ├── parent_event.dart
│   │   │       └── parent_state.dart
│   │   ├── pages/
│   │   │   ├── splash_page.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── dashboard/
│   │   │   │   └── dashboard_page.dart
│   │   │   ├── classes/
│   │   │   │   ├── classes_page.dart
│   │   │   │   ├── class_detail_page.dart
│   │   │   │   └── add_edit_class_page.dart
│   │   │   ├── teachers/
│   │   │   │   ├── teachers_page.dart
│   │   │   │   ├── teacher_detail_page.dart
│   │   │   │   └── add_edit_teacher_page.dart
│   │   │   ├── subjects/
│   │   │   │   ├── subjects_page.dart
│   │   │   │   ├── subject_detail_page.dart
│   │   │   │   └── add_edit_subject_page.dart
│   │   │   ├── students/
│   │   │   │   ├── students_page.dart
│   │   │   │   ├── student_detail_page.dart
│   │   │   │   └── add_edit_student_page.dart
│   │   │   ├── exams/
│   │   │   │   ├── exams_page.dart
│   │   │   │   ├── exam_detail_page.dart
│   │   │   │   └── add_edit_exam_page.dart
│   │   │   ├── results/
│   │   │   │   ├── results_page.dart
│   │   │   │   ├── result_detail_page.dart
│   │   │   │   └── add_edit_result_page.dart
│   │   │   ├── attendance/
│   │   │   │   ├── attendance_page.dart
│   │   │   │   ├── attendance_detail_page.dart
│   │   │   │   └── mark_attendance_page.dart
│   │   │   ├── parents/
│   │   │   │   ├── parents_page.dart
│   │   │   │   ├── parent_detail_page.dart
│   │   │   │   └── add_edit_parent_page.dart
│   │   │   └── profile/
│   │   │       ├── profile_page.dart
│   │   │       └── edit_profile_page.dart
│   │   └── widgets/
│   │       ├── common/
│   │       │   ├── app_bar_widget.dart
│   │       │   ├── bottom_navigation_widget.dart
│   │       │   ├── loading_widget.dart
│   │       │   ├── error_widget.dart
│   │       │   ├── empty_state_widget.dart
│   │       │   ├── custom_button.dart
│   │       │   ├── custom_text_field.dart
│   │       │   └── confirmation_dialog.dart
│   │       ├── cards/
│   │       │   ├── class_card.dart
│   │       │   ├── teacher_card.dart
│   │       │   ├── student_card.dart
│   │       │   ├── exam_card.dart
│   │       │   ├── result_card.dart
│   │       │   ├── attendance_card.dart
│   │       │   └── parent_card.dart
│   │       └── forms/
│   │           ├── class_form.dart
│   │           ├── teacher_form.dart
│   │           ├── subject_form.dart
│   │           ├── student_form.dart
│   │           ├── exam_form.dart
│   │           ├── result_form.dart
│   │           ├── attendance_form.dart
│   │           └── parent_form.dart
├── assets/
│   ├── images/
│   │   └── (placeholder images)
│   ├── icons/
│   │   └── (app icons)
│   ├── animations/
│   │   └── (Lottie animations)
│   └── fonts/
│       └── Poppins font files
├── test/
│   ├── domain/
│   │   └── usecases_test.dart
│   ├── data/
│   │   └── repositories_test.dart
│   └── presentation/
│       └── bloc_test.dart
├── .env.example
├── .env
├── .gitignore
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

## Architecture Overview

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (Pages, Widgets, BLoCs, Events)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       Domain Layer                  │
│  (Entities, Repositories, UseCases) │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       Data Layer                    │
│  (Models, Repositories, DataSources)│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       External Layer                │
│  (API, Local Storage, Device)       │
└─────────────────────────────────────┘
```

## Key Technologies

- **State Management**: Flutter BLoC 8.1.4
- **Navigation**: GoRouter 13.0.0
- **HTTP Client**: Dio 5.4.0
- **Local Storage**: Hive 2.2.3 + Shared Preferences
- **JSON Serialization**: json_serializable
- **UI Components**: Material 3, Google Fonts
- **Service Locator**: GetIt 7.6.0

## Features Implemented

### Authentication
- User Registration
- User Login
- Token Management
- Profile Management
- Change Password

### School Management
- **Classes**: CRUD operations, filter by grade
- **Teachers**: Staff management, specialization search
- **Subjects**: Subject catalog with search
- **Students**: Student records, performance tracking
- **Exams**: Exam scheduling and management
- **Results**: Grade tracking, GPA calculation, statistics
- **Attendance**: Attendance marking and tracking
- **Parents**: Parent/guardian information management

## BLoC Pattern Implementation

Each feature follows the BLoC pattern with:
- **Event**: User actions
- **State**: UI states (loading, success, error)
- **BLoC**: Business logic processing

Example:
```dart
// Event
abstract class ClassEvent extends Equatable {}
class GetAllClassesEvent extends ClassEvent {}

// State
abstract class ClassState extends Equatable {}
class ClassLoading extends ClassState {}
class ClassLoaded extends ClassState {
  final List<ClassEntity> classes;
}
class ClassError extends ClassState {
  final String message;
}

// BLoC
class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassUseCases useCases;
  
  ClassBloc(this.useCases) : super(ClassInitial()) {
    on<GetAllClassesEvent>(_onGetAllClasses);
  }
  
  Future<void> _onGetAllClasses(
    GetAllClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await useCases.getAllClasses();
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (classes) => emit(ClassLoaded(classes)),
    );
  }
}
```

## Data Flow

1. **UI Layer** → Triggers BLoC events
2. **BLoC** → Calls UseCases
3. **UseCases** → Calls Repository
4. **Repository** → Fetches from DataSource (API/Local)
5. **DataSource** → Returns data
6. **Repository** → Maps to Entity
7. **UseCases** → Returns result
8. **BLoC** → Emits State
9. **UI** → Rebuilds with new State

## Error Handling

- Custom exceptions for different error types
- Failure objects for error management
- Error interceptors for API errors
- User-friendly error messages

## Validation

Input validation for:
- Email format
- Password strength
- Required fields
- Phone number format
- Date format

## Navigation Flow

```
Login → Dashboard → (Classes, Teachers, Subjects, 
                    Students, Exams, Results, 
                    Attendance, Parents, Profile)
```

## Getting Started

1. Install Flutter SDK (3.0.0+)
2. Clone repository
3. Copy `.env.example` to `.env`
4. Update API base URL in `.env`
5. Run `flutter pub get`
6. Run `flutter run`

## Build & Run

```bash
# Generate models and services
flutter pub run build_runner build

# Run app
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## Code Style

- Follow Effective Dart guidelines
- Use meaningful variable names
- Add comments for complex logic
- Keep methods under 20 lines when possible
- Use const constructors

## Testing

- Unit tests for UseCases
- Widget tests for UI components
- Integration tests for features

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/domain/usecases_test.dart
```

## Contributing

1. Create feature branch: `git checkout -b feature/feature-name`
2. Commit changes: `git commit -am 'Add feature'`
3. Push branch: `git push origin feature/feature-name`
4. Create Pull Request

## Version History

- v1.0.0 - Initial release with all core features

---

**Last Updated**: June 16, 2026  
**Status**: Production Ready ✅
