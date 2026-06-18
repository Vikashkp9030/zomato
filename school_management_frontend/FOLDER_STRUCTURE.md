# Complete Folder Structure - Feature-Wise Organization

## Project Overview
School Management Frontend - Flutter app with Clean Architecture organized by features.

---

## Complete Directory Structure

```
school_management_frontend/
│
├── lib/
│   ├── main.dart                                   # App entry point
│   │
│   ├── core/                                       # Core Infrastructure
│   │   ├── constants/
│   │   │   └── app_constants.dart                 # App-wide constants
│   │   ├── di/
│   │   │   └── injection_container.dart          # Service locator setup
│   │   ├── errors/
│   │   │   ├── exceptions.dart                   # Custom exceptions
│   │   │   └── failures.dart                     # Failure objects
│   │   ├── observers/
│   │   │   └── bloc_observer.dart                # BLoC logging
│   │   └── utils/
│   │       ├── app_extensions.dart               # Dart extensions
│   │       ├── app_utils.dart                    # Utility functions
│   │       └── validators.dart                   # Input validators
│   │
│   ├── config/                                     # Configuration
│   │   ├── app_config.dart                        # Environment config
│   │   ├── routes/
│   │   │   └── router.dart                       # GoRouter setup
│   │   └── theme/
│   │       └── app_theme.dart                    # Material theme
│   │
│   ├── data/                                       # Data Layer
│   │   ├── datasources/
│   │   │   ├── local/
│   │   │   │   └── local_storage.dart            # SharedPreferences wrapper
│   │   │   └── remote/
│   │   │       ├── dio_client.dart               # HTTP client
│   │   │       ├── interceptors/
│   │   │       │   ├── auth_interceptor.dart     # Auth token interceptor
│   │   │       │   └── error_interceptor.dart    # Error handling
│   │   │       └── api_services/
│   │   │           ├── auth_api_service.dart     # Auth endpoints
│   │   │           ├── class_api_service.dart    # Classes endpoints
│   │   │           ├── teacher_api_service.dart  # Teachers endpoints
│   │   │           ├── subject_api_service.dart  # Subjects endpoints
│   │   │           ├── student_api_service.dart  # Students endpoints
│   │   │           ├── exam_api_service.dart     # Exams endpoints
│   │   │           ├── exam_result_api_service.dart # Results endpoints
│   │   │           ├── attendance_api_service.dart  # Attendance endpoints
│   │   │           └── parent_api_service.dart   # Parents endpoints
│   │   │
│   │   ├── models/                                # DTOs & Response Models
│   │   │   ├── auth/
│   │   │   │   ├── auth_response.dart
│   │   │   │   ├── login_request.dart
│   │   │   │   ├── register_request.dart
│   │   │   │   └── user_model.dart
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
│   │   │   │   ├── student_request.dart
│   │   │   │   └── student_performance_model.dart
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
│   │   │
│   │   └── repositories/                          # Repository Implementations
│   │       ├── auth_repository_impl.dart
│   │       ├── class_repository_impl.dart
│   │       ├── teacher_repository_impl.dart
│   │       ├── subject_repository_impl.dart
│   │       ├── student_repository_impl.dart
│   │       ├── exam_repository_impl.dart
│   │       ├── exam_result_repository_impl.dart
│   │       ├── attendance_repository_impl.dart
│   │       └── parent_repository_impl.dart
│   │
│   ├── domain/                                     # Domain Layer
│   │   ├── entities/                              # Business Objects
│   │   │   ├── auth_entity.dart
│   │   │   ├── class_entity.dart
│   │   │   ├── teacher_entity.dart
│   │   │   ├── subject_entity.dart
│   │   │   ├── student_entity.dart
│   │   │   ├── exam_entity.dart
│   │   │   ├── exam_result_entity.dart
│   │   │   ├── attendance_entity.dart
│   │   │   └── parent_entity.dart
│   │   │
│   │   ├── repositories/                          # Abstract Repositories
│   │   │   ├── auth_repository.dart
│   │   │   ├── class_repository.dart
│   │   │   ├── teacher_repository.dart
│   │   │   ├── subject_repository.dart
│   │   │   ├── student_repository.dart
│   │   │   ├── exam_repository.dart
│   │   │   ├── exam_result_repository.dart
│   │   │   ├── attendance_repository.dart
│   │   │   └── parent_repository.dart
│   │   │
│   │   └── usecases/                              # Business Logic
│   │       ├── auth_usecases.dart
│   │       ├── class_usecases.dart
│   │       ├── teacher_usecases.dart
│   │       ├── subject_usecases.dart
│   │       ├── student_usecases.dart
│   │       ├── exam_usecases.dart
│   │       ├── exam_result_usecases.dart
│   │       ├── attendance_usecases.dart
│   │       └── parent_usecases.dart
│   │
│   └── presentation/                              # Presentation Layer
│       ├── bloc/                                  # State Management
│       │   ├── auth/
│       │   │   ├── auth_bloc.dart
│       │   │   ├── auth_event.dart
│       │   │   └── auth_state.dart
│       │   ├── class/
│       │   │   ├── class_bloc.dart
│       │   │   ├── class_event.dart
│       │   │   └── class_state.dart
│       │   ├── teacher/
│       │   │   ├── teacher_bloc.dart
│       │   │   ├── teacher_event.dart
│       │   │   └── teacher_state.dart
│       │   ├── subject/
│       │   │   ├── subject_bloc.dart
│       │   │   ├── subject_event.dart
│       │   │   └── subject_state.dart
│       │   ├── student/
│       │   │   ├── student_bloc.dart
│       │   │   ├── student_event.dart
│       │   │   └── student_state.dart
│       │   ├── exam/
│       │   │   ├── exam_bloc.dart
│       │   │   ├── exam_event.dart
│       │   │   └── exam_state.dart
│       │   ├── exam_result/
│       │   │   ├── exam_result_bloc.dart
│       │   │   ├── exam_result_event.dart
│       │   │   └── exam_result_state.dart
│       │   ├── attendance/
│       │   │   ├── attendance_bloc.dart
│       │   │   ├── attendance_event.dart
│       │   │   └── attendance_state.dart
│       │   └── parent/
│       │       ├── parent_bloc.dart
│       │       ├── parent_event.dart
│       │       └── parent_state.dart
│       │
│       ├── pages/                                 # Full Screen Pages
│       │   ├── splash_page.dart                  # Splash screen
│       │   ├── auth/
│       │   │   ├── login_page.dart
│       │   │   └── register_page.dart
│       │   ├── dashboard/
│       │   │   └── dashboard_page.dart
│       │   ├── classes/
│       │   │   ├── classes_page.dart             # List view
│       │   │   ├── class_detail_page.dart        # Detail view
│       │   │   └── add_edit_class_page.dart      # Add/Edit form
│       │   ├── teachers/
│       │   │   ├── teachers_page.dart
│       │   │   ├── teacher_detail_page.dart
│       │   │   └── add_edit_teacher_page.dart
│       │   ├── subjects/
│       │   │   ├── subjects_page.dart
│       │   │   ├── subject_detail_page.dart
│       │   │   └── add_edit_subject_page.dart
│       │   ├── students/
│       │   │   ├── students_page.dart
│       │   │   ├── student_detail_page.dart
│       │   │   └── add_edit_student_page.dart
│       │   ├── exams/
│       │   │   ├── exams_page.dart
│       │   │   ├── exam_detail_page.dart
│       │   │   └── add_edit_exam_page.dart
│       │   ├── results/
│       │   │   ├── results_page.dart
│       │   │   ├── result_detail_page.dart
│       │   │   └── add_edit_result_page.dart
│       │   ├── attendance/
│       │   │   ├── attendance_page.dart
│       │   │   ├── attendance_detail_page.dart
│       │   │   └── mark_attendance_page.dart
│       │   ├── parents/
│       │   │   ├── parents_page.dart
│       │   │   ├── parent_detail_page.dart
│       │   │   └── add_edit_parent_page.dart
│       │   └── profile/
│       │       ├── profile_page.dart
│       │       └── edit_profile_page.dart
│       │
│       └── widgets/                               # Reusable Components
│           ├── common/
│           │   ├── app_bar_widget.dart           # Custom AppBar
│           │   ├── bottom_navigation_widget.dart # Navigation bar
│           │   ├── loading_widget.dart           # Loading indicator
│           │   ├── error_widget.dart             # Error display
│           │   ├── empty_state_widget.dart       # Empty state
│           │   ├── custom_button.dart            # Custom button
│           │   ├── custom_text_field.dart        # Custom textfield
│           │   └── confirmation_dialog.dart      # Confirmation modal
│           ├── cards/
│           │   ├── class_card.dart               # Class list item
│           │   ├── teacher_card.dart             # Teacher list item
│           │   ├── student_card.dart             # Student list item
│           │   ├── exam_card.dart                # Exam list item
│           │   ├── result_card.dart              # Result list item
│           │   ├── attendance_card.dart          # Attendance list item
│           │   └── parent_card.dart              # Parent list item
│           └── forms/
│               ├── class_form.dart               # Class form
│               ├── teacher_form.dart             # Teacher form
│               ├── subject_form.dart             # Subject form
│               ├── student_form.dart             # Student form
│               ├── exam_form.dart                # Exam form
│               ├── result_form.dart              # Result form
│               ├── attendance_form.dart          # Attendance form
│               └── parent_form.dart              # Parent form
│
├── assets/
│   ├── images/                                    # App images
│   ├── icons/                                     # App icons
│   ├── animations/                                # Lottie animations
│   └── fonts/                                     # Custom fonts
│
├── test/
│   ├── domain/
│   │   └── usecases_test.dart                    # UseCase tests
│   ├── data/
│   │   └── repositories_test.dart                # Repository tests
│   └── presentation/
│       └── bloc_test.dart                        # BLoC tests
│
├── pubspec.yaml                                   # Dependencies
├── pubspec.lock                                   # Lock file
├── .env.example                                   # Environment template
├── .env                                           # Environment variables
├── .gitignore                                     # Git ignore
├── analysis_options.yaml                          # Dart linter config
└── README.md                                      # Project readme
```

---

## Feature-Wise Organization

### 1. **Authentication Feature**
```
Feature: Auth
├── Data Layer
│   ├── API Service: auth_api_service.dart
│   ├── Models: auth_response, login_request, register_request, user_model
│   └── Repository: auth_repository_impl.dart
├── Domain Layer
│   ├── Entity: auth_entity.dart
│   ├── Repository: auth_repository.dart
│   └── UseCases: auth_usecases.dart
└── Presentation Layer
    ├── BLoC: auth_bloc, auth_event, auth_state
    ├── Pages: login_page, register_page
    └── Widgets: (uses common widgets)

API Endpoints:
- POST /auth/login
- POST /auth/register
- POST /auth/logout
- POST /auth/refresh-token
- POST /auth/forgot-password
- POST /auth/reset-password
- POST /auth/verify-email
```

### 2. **Classes Feature**
```
Feature: Classes
├── Data Layer
│   ├── API Service: class_api_service.dart
│   ├── Models: class_model, class_request, class_info_model
│   └── Repository: class_repository_impl.dart
├── Domain Layer
│   ├── Entity: class_entity.dart
│   ├── Repository: class_repository.dart
│   └── UseCases: class_usecases.dart
└── Presentation Layer
    ├── BLoC: class_bloc, class_event, class_state
    ├── Pages: classes_page, class_detail_page, add_edit_class_page
    └── Widgets: class_card, class_form

API Endpoints:
- GET /classes (with pagination & filters)
- GET /classes/:id
- POST /classes
- PUT /classes/:id
- DELETE /classes/:id
- GET /classes/:id/students
- GET /classes/:id/subjects
```

### 3. **Teachers Feature**
```
Feature: Teachers
├── Data Layer
│   ├── API Service: teacher_api_service.dart
│   ├── Models: teacher_model, teacher_request
│   └── Repository: teacher_repository_impl.dart
├── Domain Layer
│   ├── Entity: teacher_entity.dart
│   ├── Repository: teacher_repository.dart
│   └── UseCases: teacher_usecases.dart
└── Presentation Layer
    ├── BLoC: teacher_bloc, teacher_event, teacher_state
    ├── Pages: teachers_page, teacher_detail_page, add_edit_teacher_page
    └── Widgets: teacher_card, teacher_form

API Endpoints:
- GET /teachers (with pagination & filters)
- GET /teachers/:id
- POST /teachers
- PUT /teachers/:id
- DELETE /teachers/:id
- GET /teachers/:id/classes
- GET /teachers/:id/subjects
- POST /teachers/:id/assign-class
```

### 4. **Subjects Feature**
```
Feature: Subjects
├── Data Layer
│   ├── API Service: subject_api_service.dart
│   ├── Models: subject_model, subject_request
│   └── Repository: subject_repository_impl.dart
├── Domain Layer
│   ├── Entity: subject_entity.dart
│   ├── Repository: subject_repository.dart
│   └── UseCases: subject_usecases.dart
└── Presentation Layer
    ├── BLoC: subject_bloc, subject_event, subject_state
    ├── Pages: subjects_page, subject_detail_page, add_edit_subject_page
    └── Widgets: (subject card & form - to create)

API Endpoints:
- GET /subjects (with pagination & filters)
- GET /subjects/:id
- POST /subjects
- PUT /subjects/:id
- DELETE /subjects/:id
- GET /subjects/:id/teachers
- GET /subjects/:id/classes
- POST /subjects/:id/assign-class
```

### 5. **Students Feature**
```
Feature: Students
├── Data Layer
│   ├── API Service: student_api_service.dart
│   ├── Models: student_model, student_request, student_performance_model
│   └── Repository: student_repository_impl.dart
├── Domain Layer
│   ├── Entity: student_entity.dart
│   ├── Repository: student_repository.dart
│   └── UseCases: student_usecases.dart
└── Presentation Layer
    ├── BLoC: student_bloc, student_event, student_state
    ├── Pages: students_page, student_detail_page, add_edit_student_page
    └── Widgets: student_card, student_form

API Endpoints:
- GET /students (with pagination & filters)
- GET /students/:id
- POST /students
- PUT /students/:id
- DELETE /students/:id
- GET /students/:id/performance
- GET /students/:id/results
- GET /students/:id/attendance
- POST /students/:id/promote
```

### 6. **Exams Feature**
```
Feature: Exams
├── Data Layer
│   ├── API Service: exam_api_service.dart
│   ├── Models: exam_model, exam_request
│   └── Repository: exam_repository_impl.dart
├── Domain Layer
│   ├── Entity: exam_entity.dart
│   ├── Repository: exam_repository.dart
│   └── UseCases: exam_usecases.dart
└── Presentation Layer
    ├── BLoC: exam_bloc, exam_event, exam_state
    ├── Pages: exams_page, exam_detail_page, add_edit_exam_page
    └── Widgets: exam_card, exam_form

API Endpoints:
- GET /exams (with pagination & filters)
- GET /exams/:id
- POST /exams
- PUT /exams/:id
- DELETE /exams/:id
- GET /exams/schedule
- GET /exams/:id/results
- POST /exams/:id/publish
```

### 7. **Exam Results Feature**
```
Feature: ExamResults
├── Data Layer
│   ├── API Service: exam_result_api_service.dart
│   ├── Models: exam_result_model, exam_result_request, exam_stats_model
│   └── Repository: exam_result_repository_impl.dart
├── Domain Layer
│   ├── Entity: exam_result_entity.dart
│   ├── Repository: exam_result_repository.dart
│   └── UseCases: exam_result_usecases.dart
└── Presentation Layer
    ├── BLoC: exam_result_bloc, exam_result_event, exam_result_state
    ├── Pages: results_page, result_detail_page, add_edit_result_page
    └── Widgets: result_card, result_form

API Endpoints:
- GET /results (with pagination & filters)
- GET /results/:id
- POST /results
- PUT /results/:id
- DELETE /results/:id
- GET /results/student/:id
- GET /results/class/:id
- GET /results/student/:id/gpa
- GET /results/exam/:id/statistics
- GET /results/class/:id/top-performers
```

### 8. **Attendance Feature**
```
Feature: Attendance
├── Data Layer
│   ├── API Service: attendance_api_service.dart
│   ├── Models: attendance_model, attendance_request, attendance_summary_model
│   └── Repository: attendance_repository_impl.dart
├── Domain Layer
│   ├── Entity: attendance_entity.dart
│   ├── Repository: attendance_repository.dart
│   └── UseCases: attendance_usecases.dart
└── Presentation Layer
    ├── BLoC: attendance_bloc, attendance_event, attendance_state
    ├── Pages: attendance_page, attendance_detail_page, mark_attendance_page
    └── Widgets: attendance_card, attendance_form

API Endpoints:
- GET /attendance (with pagination & filters)
- GET /attendance/:id
- POST /attendance
- PUT /attendance/:id
- DELETE /attendance/:id
- GET /attendance/student/:id
- GET /attendance/class/:id
- GET /attendance/student/:id/summary
- POST /attendance/bulk
- GET /attendance/report
```

### 9. **Parents Feature**
```
Feature: Parents
├── Data Layer
│   ├── API Service: parent_api_service.dart
│   ├── Models: parent_model, parent_request
│   └── Repository: parent_repository_impl.dart
├── Domain Layer
│   ├── Entity: parent_entity.dart
│   ├── Repository: parent_repository.dart
│   └── UseCases: parent_usecases.dart
└── Presentation Layer
    ├── BLoC: parent_bloc, parent_event, parent_state
    ├── Pages: parents_page, parent_detail_page, add_edit_parent_page
    └── Widgets: parent_card, parent_form

API Endpoints:
- GET /parents (with pagination & filters)
- GET /parents/:id
- POST /parents
- PUT /parents/:id
- DELETE /parents/:id
- GET /parents/:id/children
- POST /parents/:id/link-student
- POST /parents/:id/unlink-student
- GET /parents/:id/student/:id/progress
- POST /parents/:id/message
```

### 10. **Profile Feature**
```
Feature: Profile
├── Data Layer
│   └── API Service: (uses auth_api_service for profile updates)
├── Domain Layer
│   └── (uses existing auth entities & repositories)
└── Presentation Layer
    ├── Pages: profile_page, edit_profile_page
    └── Widgets: (profile-specific widgets)

API Endpoints:
- GET /profile
- PUT /profile
- POST /profile/change-password
- POST /profile/upload-avatar
```

---

## Layer Responsibilities

### Data Layer
- **API Services**: Define HTTP endpoints
- **Models**: DTOs from/to API
- **Repositories**: Implement abstract repositories, handle API calls, error mapping

### Domain Layer
- **Entities**: Pure business objects
- **Repositories**: Abstract interfaces
- **UseCases**: Business logic, orchestrate operations

### Presentation Layer
- **BLoC**: State management
- **Events**: User actions
- **States**: UI states
- **Pages**: Full screen widgets
- **Widgets**: Reusable components

---

## File Count Summary

| Layer | Category | Count |
|-------|----------|-------|
| Core | Infrastructure | 10+ |
| Config | Configuration | 5 |
| Data | API Services | 9 |
| Data | Models | 27+ |
| Data | Repositories | 9 |
| Domain | Entities | 10 |
| Domain | Repositories | 10 |
| Domain | UseCases | 9 |
| Presentation | BLoCs | 27 (9 modules × 3) |
| Presentation | Pages | 30+ |
| Presentation | Widgets | 20+ |
| **Total** | | **180+** |

---

## File Naming Conventions

### Controllers/BLoC
```
{feature}_bloc.dart          # Main BLoC class
{feature}_event.dart         # Events
{feature}_state.dart         # States
```

### Pages/Screens
```
{feature}s_page.dart         # List page (plural)
{feature}_detail_page.dart   # Detail page
add_edit_{feature}_page.dart # Add/Edit page
```

### Repositories
```
{feature}_repository.dart           # Abstract (Domain)
{feature}_repository_impl.dart      # Implementation (Data)
```

### Models
```
{feature}_model.dart         # Response/API model
{feature}_request.dart       # Request model
{feature}_entity.dart        # Domain entity
```

### API Services
```
{feature}_api_service.dart   # API endpoints
```

---

## Import Organization

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Package imports
import 'package:dartz/dartz.dart';

// 4. Relative imports
import '../../../core/errors/failures.dart';
import '../../entities/user_entity.dart';
```

---

## Best Practices

1. **One class per file** - Easier to navigate
2. **Organized imports** - Standard organization
3. **Feature-based structure** - Easy to add/remove features
4. **Clean separation** - Clear layer boundaries
5. **Consistent naming** - Easy to find files
6. **DRY principle** - Reuse common widgets

---

**Last Updated**: June 16, 2026  
**Status**: Complete structure with all 9 feature modules + auth
