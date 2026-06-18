# Flutter School Management App - Feature-Based Clean Architecture Refactoring Plan

## Executive Summary
This document outlines a comprehensive refactoring plan to migrate the current monolithic clean architecture structure into a feature-based modular clean architecture. This will improve code scalability, maintainability, and enable independent feature development.

---

## Current Structure Analysis

### Current Directory Tree
```
lib/
├── config/
│   ├── app_config.dart
│   ├── routes/
│   │   └── router.dart
│   └── theme/
│       └── app_theme.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── di/
│   │   └── injection_container.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── observers/
│       └── bloc_observer.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── local_storage.dart
│   │   └── remote/
│   │       ├── api_services/
│   │       │   ├── attendance_api_service.dart
│   │       │   ├── auth_api_service.dart
│   │       │   ├── class_api_service.dart
│   │       │   ├── exam_api_service.dart
│   │       │   ├── exam_result_api_service.dart
│   │       │   ├── parent_api_service.dart
│   │       │   ├── student_api_service.dart
│   │       │   ├── subject_api_service.dart
│   │       │   └── teacher_api_service.dart
│   │       ├── dio_client.dart
│   │       └── interceptors/
│   │           ├── auth_interceptor.dart
│   │           └── error_interceptor.dart
│   ├── models/
│   │   ├── attendance/
│   │   │   └── attendance_model.dart
│   │   ├── auth/
│   │   │   ├── auth_response.dart
│   │   │   ├── login_request.dart
│   │   │   ├── register_request.dart
│   │   │   └── user_model.dart
│   │   ├── class/
│   │   │   └── class_model.dart
│   │   ├── exam/
│   │   │   └── exam_model.dart
│   │   ├── exam_result/
│   │   │   └── exam_result_model.dart
│   │   ├── parent/
│   │   │   └── parent_model.dart
│   │   ├── student/
│   │   │   └── student_model.dart
│   │   ├── subject/
│   │   │   └── subject_model.dart
│   │   └── teacher/
│   │       └── teacher_model.dart
│   └── repositories/
│       ├── attendance_repository_impl.dart
│       ├── auth_repository_impl.dart
│       ├── class_repository_impl.dart
│       ├── exam_repository_impl.dart
│       ├── exam_result_repository_impl.dart
│       ├── parent_repository_impl.dart
│       ├── student_repository_impl.dart
│       ├── subject_repository_impl.dart
│       └── teacher_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── all_entities.dart
│   │   └── auth_entity.dart
│   ├── repositories/
│   │   ├── all_repositories.dart
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── attendance_usecases.dart
│       ├── auth_usecases.dart
│       ├── class_usecases.dart
│       ├── exam_result_usecases.dart
│       ├── exam_usecases.dart
│       ├── parent_usecases.dart
│       ├── student_usecases.dart
│       ├── subject_usecases.dart
│       └── teacher_usecases.dart
├── presentation/
│   ├── bloc/
│   │   ├── attendance/
│   │   │   ├── attendance_bloc.dart
│   │   │   ├── attendance_event.dart
│   │   │   └── attendance_state.dart
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── class/
│   │   │   ├── class_bloc.dart
│   │   │   ├── class_event.dart
│   │   │   └── class_state.dart
│   │   ├── exam/
│   │   │   ├── exam_bloc.dart
│   │   │   ├── exam_event.dart
│   │   │   └── exam_state.dart
│   │   ├── exam_result/
│   │   │   ├── exam_result_bloc.dart
│   │   │   ├── exam_result_event.dart
│   │   │   └── exam_result_state.dart
│   │   ├── parent/
│   │   │   ├── parent_bloc.dart
│   │   │   ├── parent_event.dart
│   │   │   └── parent_state.dart
│   │   ├── student/
│   │   │   ├── student_bloc.dart
│   │   │   ├── student_event.dart
│   │   │   └── student_state.dart
│   │   ├── subject/
│   │   │   ├── subject_bloc.dart
│   │   │   ├── subject_event.dart
│   │   │   └── subject_state.dart
│   │   └── teacher/
│   │       ├── teacher_bloc.dart
│   │       ├── teacher_event.dart
│   │       └── teacher_state.dart
│   └── pages/
│       ├── auth/
│       │   ├── login_page.dart
│       │   └── register_page.dart
│       ├── classes_page.dart
│       ├── dashboard/
│       │   └── dashboard_page.dart
│       └── splash_page.dart
└── main.dart
```

### Current Issues
1. **Data/Domain Coupling**: All repositories (interfaces and implementations) are in separate folders, but lack feature isolation
2. **Shared Concerns**: API services, models, and datasources are globally organized without feature boundaries
3. **Monolithic Injection**: `injection_container.dart` contains all registrations mixed together
4. **Routing Coupling**: Routes are globally defined in `config/routes/router.dart`
5. **Scalability Issues**: Adding new features requires touching core files; new features contaminate existing structure
6. **Limited Modularity**: Difficult to develop, test, or extract features independently

---

## Target Structure (Feature-Based Clean Architecture)

### New Directory Tree
```
lib/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── auth_response_model.dart
│   │   │   │   ├── login_request_model.dart
│   │   │   │   ├── register_request_model.dart
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── auth_entity.dart
│   │   │   │   └── token_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       ├── refresh_token_usecase.dart
│   │   │       ├── request_password_reset_usecase.dart
│   │   │       ├── reset_password_usecase.dart
│   │   │       ├── verify_email_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           ├── login_form_widget.dart
│   │           ├── register_form_widget.dart
│   │           └── auth_error_widget.dart
│   │
│   ├── students/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── student_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── student_model.dart
│   │   │   └── repositories/
│   │   │       └── student_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── student_entity.dart
│   │   │   │   └── student_performance_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── student_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_students_usecase.dart
│   │   │       ├── get_student_by_id_usecase.dart
│   │   │       ├── create_student_usecase.dart
│   │   │       ├── update_student_usecase.dart
│   │   │       ├── delete_student_usecase.dart
│   │   │       ├── get_student_performance_usecase.dart
│   │   │       ├── get_student_results_usecase.dart
│   │   │       └── get_student_attendance_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── student_bloc.dart
│   │       │   ├── student_event.dart
│   │       │   └── student_state.dart
│   │       ├── pages/
│   │       │   ├── students_page.dart
│   │       │   ├── student_detail_page.dart
│   │       │   └── add_student_page.dart
│   │       └── widgets/
│   │           ├── student_list_widget.dart
│   │           ├── student_card_widget.dart
│   │           ├── student_form_widget.dart
│   │           └── student_performance_widget.dart
│   │
│   ├── teachers/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── teacher_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── teacher_model.dart
│   │   │   └── repositories/
│   │   │       └── teacher_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── teacher_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── teacher_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_teachers_usecase.dart
│   │   │       ├── get_teacher_by_id_usecase.dart
│   │   │       ├── create_teacher_usecase.dart
│   │   │       ├── update_teacher_usecase.dart
│   │   │       ├── delete_teacher_usecase.dart
│   │   │       ├── get_teacher_classes_usecase.dart
│   │   │       └── get_teacher_subjects_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── teacher_bloc.dart
│   │       │   ├── teacher_event.dart
│   │       │   └── teacher_state.dart
│   │       ├── pages/
│   │       │   ├── teachers_page.dart
│   │       │   ├── teacher_detail_page.dart
│   │       │   └── add_teacher_page.dart
│   │       └── widgets/
│   │           ├── teacher_list_widget.dart
│   │           ├── teacher_card_widget.dart
│   │           └── teacher_form_widget.dart
│   │
│   ├── classes/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── class_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── class_model.dart
│   │   │   └── repositories/
│   │   │       └── class_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── class_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── class_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_classes_usecase.dart
│   │   │       ├── get_class_by_id_usecase.dart
│   │   │       ├── create_class_usecase.dart
│   │   │       ├── update_class_usecase.dart
│   │   │       ├── delete_class_usecase.dart
│   │   │       ├── get_class_students_usecase.dart
│   │   │       └── get_class_subjects_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── class_bloc.dart
│   │       │   ├── class_event.dart
│   │       │   └── class_state.dart
│   │       ├── pages/
│   │       │   ├── classes_page.dart
│   │       │   ├── class_detail_page.dart
│   │       │   └── add_class_page.dart
│   │       └── widgets/
│   │           ├── class_list_widget.dart
│   │           ├── class_card_widget.dart
│   │           └── class_form_widget.dart
│   │
│   ├── subjects/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── subject_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── subject_model.dart
│   │   │   └── repositories/
│   │   │       └── subject_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── subject_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── subject_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_subjects_usecase.dart
│   │   │       ├── get_subject_by_id_usecase.dart
│   │   │       ├── create_subject_usecase.dart
│   │   │       ├── update_subject_usecase.dart
│   │   │       ├── delete_subject_usecase.dart
│   │   │       ├── get_subject_teachers_usecase.dart
│   │   │       └── get_subject_classes_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── subject_bloc.dart
│   │       │   ├── subject_event.dart
│   │       │   └── subject_state.dart
│   │       ├── pages/
│   │       │   ├── subjects_page.dart
│   │       │   ├── subject_detail_page.dart
│   │       │   └── add_subject_page.dart
│   │       └── widgets/
│   │           ├── subject_list_widget.dart
│   │           ├── subject_card_widget.dart
│   │           └── subject_form_widget.dart
│   │
│   ├── attendance/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── attendance_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── attendance_model.dart
│   │   │   │   └── attendance_summary_model.dart
│   │   │   └── repositories/
│   │   │       └── attendance_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── attendance_entity.dart
│   │   │   │   └── attendance_summary_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── attendance_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_attendance_usecase.dart
│   │   │       ├── get_attendance_by_id_usecase.dart
│   │   │       ├── mark_attendance_usecase.dart
│   │   │       ├── update_attendance_usecase.dart
│   │   │       ├── delete_attendance_usecase.dart
│   │   │       ├── get_student_attendance_usecase.dart
│   │   │       ├── get_class_attendance_usecase.dart
│   │   │       ├── get_attendance_summary_usecase.dart
│   │   │       └── mark_bulk_attendance_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── attendance_bloc.dart
│   │       │   ├── attendance_event.dart
│   │       │   └── attendance_state.dart
│   │       ├── pages/
│   │       │   ├── attendance_page.dart
│   │       │   ├── mark_attendance_page.dart
│   │       │   └── attendance_summary_page.dart
│   │       └── widgets/
│   │           ├── attendance_list_widget.dart
│   │           ├── attendance_form_widget.dart
│   │           ├── attendance_calendar_widget.dart
│   │           └── attendance_summary_widget.dart
│   │
│   ├── exams/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── exam_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── exam_model.dart
│   │   │   └── repositories/
│   │   │       └── exam_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── exam_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── exam_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_exams_usecase.dart
│   │   │       ├── get_exam_by_id_usecase.dart
│   │   │       ├── create_exam_usecase.dart
│   │   │       ├── update_exam_usecase.dart
│   │   │       ├── delete_exam_usecase.dart
│   │   │       ├── get_upcoming_exams_usecase.dart
│   │   │       ├── get_exams_by_class_usecase.dart
│   │   │       └── get_exam_results_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── exam_bloc.dart
│   │       │   ├── exam_event.dart
│   │       │   └── exam_state.dart
│   │       ├── pages/
│   │       │   ├── exams_page.dart
│   │       │   ├── exam_detail_page.dart
│   │       │   └── add_exam_page.dart
│   │       └── widgets/
│   │           ├── exam_list_widget.dart
│   │           ├── exam_card_widget.dart
│   │           ├── exam_form_widget.dart
│   │           └── upcoming_exams_widget.dart
│   │
│   ├── exam_results/ (or grades)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── exam_result_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── exam_result_model.dart
│   │   │   │   └── exam_stats_model.dart
│   │   │   └── repositories/
│   │   │       └── exam_result_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── exam_result_entity.dart
│   │   │   │   └── exam_stats_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── exam_result_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_results_usecase.dart
│   │   │       ├── get_result_by_id_usecase.dart
│   │   │       ├── create_result_usecase.dart
│   │   │       ├── update_result_usecase.dart
│   │   │       ├── delete_result_usecase.dart
│   │   │       ├── get_student_results_usecase.dart
│   │   │       ├── get_class_results_usecase.dart
│   │   │       └── get_exam_statistics_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── exam_result_bloc.dart
│   │       │   ├── exam_result_event.dart
│   │       │   └── exam_result_state.dart
│   │       ├── pages/
│   │       │   ├── exam_results_page.dart
│   │       │   ├── result_detail_page.dart
│   │       │   ├── add_result_page.dart
│   │       │   └── exam_statistics_page.dart
│   │       └── widgets/
│   │           ├── result_list_widget.dart
│   │           ├── result_card_widget.dart
│   │           ├── result_form_widget.dart
│   │           ├── statistics_chart_widget.dart
│   │           └── grade_widget.dart
│   │
│   ├── fees/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── fee_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── fee_model.dart
│   │   │   │   └── payment_model.dart
│   │   │   └── repositories/
│   │   │       └── fee_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── fee_entity.dart
│   │   │   │   └── payment_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── fee_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_fees_usecase.dart
│   │   │       ├── get_fee_by_id_usecase.dart
│   │   │       ├── get_student_fees_usecase.dart
│   │   │       ├── create_fee_usecase.dart
│   │   │       ├── process_payment_usecase.dart
│   │   │       ├── get_payment_history_usecase.dart
│   │   │       └── get_fee_statistics_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── fee_bloc.dart
│   │       │   ├── fee_event.dart
│   │       │   └── fee_state.dart
│   │       ├── pages/
│   │       │   ├── fees_page.dart
│   │       │   ├── fee_detail_page.dart
│   │       │   ├── payment_page.dart
│   │       │   └── fee_statistics_page.dart
│   │       └── widgets/
│   │           ├── fee_list_widget.dart
│   │           ├── fee_card_widget.dart
│   │           ├── payment_form_widget.dart
│   │           └── fee_statistics_widget.dart
│   │
│   ├── timetable/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── timetable_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── timetable_model.dart
│   │   │   └── repositories/
│   │   │       └── timetable_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── timetable_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── timetable_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_class_timetable_usecase.dart
│   │   │       ├── get_teacher_timetable_usecase.dart
│   │   │       ├── create_timetable_usecase.dart
│   │   │       ├── update_timetable_usecase.dart
│   │   │       └── get_student_timetable_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── timetable_bloc.dart
│   │       │   ├── timetable_event.dart
│   │       │   └── timetable_state.dart
│   │       ├── pages/
│   │       │   └── timetable_page.dart
│   │       └── widgets/
│   │           ├── timetable_view_widget.dart
│   │           ├── timetable_form_widget.dart
│   │           └── schedule_card_widget.dart
│   │
│   ├── library/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── library_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── book_model.dart
│   │   │   │   └── book_issue_model.dart
│   │   │   └── repositories/
│   │   │       └── library_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── book_entity.dart
│   │   │   │   └── book_issue_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── library_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_books_usecase.dart
│   │   │       ├── search_books_usecase.dart
│   │   │       ├── issue_book_usecase.dart
│   │   │       ├── return_book_usecase.dart
│   │   │       └── get_student_issued_books_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── library_bloc.dart
│   │       │   ├── library_event.dart
│   │       │   └── library_state.dart
│   │       ├── pages/
│   │       │   ├── library_page.dart
│   │       │   ├── book_detail_page.dart
│   │       │   └── issued_books_page.dart
│   │       └── widgets/
│   │           ├── book_list_widget.dart
│   │           ├── book_card_widget.dart
│   │           ├── book_search_widget.dart
│   │           └── book_issue_form_widget.dart
│   │
│   ├── transport/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── transport_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── vehicle_model.dart
│   │   │   │   ├── route_model.dart
│   │   │   │   └── student_transport_model.dart
│   │   │   └── repositories/
│   │   │       └── transport_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── vehicle_entity.dart
│   │   │   │   ├── route_entity.dart
│   │   │   │   └── student_transport_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── transport_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_vehicles_usecase.dart
│   │   │       ├── get_all_routes_usecase.dart
│   │   │       ├── get_vehicle_students_usecase.dart
│   │   │       ├── assign_student_to_route_usecase.dart
│   │   │       └── get_student_route_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── transport_bloc.dart
│   │       │   ├── transport_event.dart
│   │       │   └── transport_state.dart
│   │       ├── pages/
│   │       │   ├── transport_page.dart
│   │       │   ├── route_detail_page.dart
│   │       │   └── vehicle_detail_page.dart
│   │       └── widgets/
│   │           ├── route_list_widget.dart
│   │           ├── vehicle_list_widget.dart
│   │           ├── vehicle_card_widget.dart
│   │           └── route_map_widget.dart
│   │
│   ├── hostel/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── hostel_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── hostel_model.dart
│   │   │   │   ├── room_model.dart
│   │   │   │   └── student_hostel_model.dart
│   │   │   └── repositories/
│   │   │       └── hostel_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── hostel_entity.dart
│   │   │   │   ├── room_entity.dart
│   │   │   │   └── student_hostel_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── hostel_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_hostels_usecase.dart
│   │   │       ├── get_hostel_rooms_usecase.dart
│   │   │       ├── assign_student_to_room_usecase.dart
│   │   │       ├── get_student_hostel_usecase.dart
│   │   │       └── get_room_occupancy_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── hostel_bloc.dart
│   │       │   ├── hostel_event.dart
│   │       │   └── hostel_state.dart
│   │       ├── pages/
│   │       │   ├── hostel_page.dart
│   │       │   ├── hostel_detail_page.dart
│   │       │   └── room_detail_page.dart
│   │       └── widgets/
│   │           ├── hostel_list_widget.dart
│   │           ├── room_list_widget.dart
│   │           ├── room_card_widget.dart
│   │           └── occupancy_widget.dart
│   │
│   ├── payroll/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── payroll_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── payroll_model.dart
│   │   │   │   ├── salary_model.dart
│   │   │   │   └── payment_record_model.dart
│   │   │   └── repositories/
│   │   │       └── payroll_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── payroll_entity.dart
│   │   │   │   ├── salary_entity.dart
│   │   │   │   └── payment_record_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── payroll_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_payrolls_usecase.dart
│   │   │       ├── get_payroll_by_id_usecase.dart
│   │   │       ├── create_payroll_usecase.dart
│   │   │       ├── process_payroll_usecase.dart
│   │   │       ├── get_payment_history_usecase.dart
│   │   │       └── get_payroll_statistics_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── payroll_bloc.dart
│   │       │   ├── payroll_event.dart
│   │       │   └── payroll_state.dart
│   │       ├── pages/
│   │       │   ├── payroll_page.dart
│   │       │   ├── payroll_detail_page.dart
│   │       │   ├── salary_slip_page.dart
│   │       │   └── payroll_statistics_page.dart
│   │       └── widgets/
│   │           ├── payroll_list_widget.dart
│   │           ├── payroll_card_widget.dart
│   │           ├── salary_slip_widget.dart
│   │           └── payroll_statistics_widget.dart
│   │
│   ├── reports/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── report_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── academic_report_model.dart
│   │   │   │   ├── financial_report_model.dart
│   │   │   │   └── attendance_report_model.dart
│   │   │   └── repositories/
│   │   │       └── report_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── academic_report_entity.dart
│   │   │   │   ├── financial_report_entity.dart
│   │   │   │   └── attendance_report_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── report_repository.dart
│   │   │   └── usecases/
│   │   │       ├── generate_academic_report_usecase.dart
│   │   │       ├── generate_financial_report_usecase.dart
│   │   │       ├── generate_attendance_report_usecase.dart
│   │   │       ├── export_report_usecase.dart
│   │   │       └── get_report_history_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── report_bloc.dart
│   │       │   ├── report_event.dart
│   │       │   └── report_state.dart
│   │       ├── pages/
│   │       │   ├── reports_page.dart
│   │       │   ├── academic_report_page.dart
│   │       │   ├── financial_report_page.dart
│   │       │   └── attendance_report_page.dart
│   │       └── widgets/
│   │           ├── report_list_widget.dart
│   │           ├── report_chart_widget.dart
│   │           ├── report_filters_widget.dart
│   │           ├── export_options_widget.dart
│   │           └── report_detail_widget.dart
│   │
│   ├── notifications/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── notification_local_datasource.dart
│   │   │   │   └── notification_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_notifications_usecase.dart
│   │   │       ├── mark_as_read_usecase.dart
│   │   │       ├── delete_notification_usecase.dart
│   │   │       ├── send_notification_usecase.dart
│   │   │       └── get_unread_count_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── notification_bloc.dart
│   │       │   ├── notification_event.dart
│   │       │   └── notification_state.dart
│   │       ├── pages/
│   │       │   └── notifications_page.dart
│   │       └── widgets/
│   │           ├── notification_list_widget.dart
│   │           ├── notification_card_widget.dart
│   │           └── notification_bell_widget.dart
│   │
│   └── dashboard/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── dashboard_remote_datasource.dart
│       │   ├── models/
│       │   │   └── dashboard_stats_model.dart
│       │   └── repositories/
│       │       └── dashboard_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── dashboard_stats_entity.dart
│       │   ├── repositories/
│       │   │   └── dashboard_repository.dart
│       │   └── usecases/
│       │       ├── get_dashboard_stats_usecase.dart
│       │       ├── get_student_stats_usecase.dart
│       │       ├── get_teacher_stats_usecase.dart
│       │       ├── get_financial_stats_usecase.dart
│       │       └── get_attendance_stats_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── dashboard_bloc.dart
│           │   ├── dashboard_event.dart
│           │   └── dashboard_state.dart
│           ├── pages/
│           │   └── dashboard_page.dart
│           └── widgets/
│               ├── stats_card_widget.dart
│               ├── chart_widget.dart
│               ├── quick_actions_widget.dart
│               └── upcoming_events_widget.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── app_strings.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   └── error_handler.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_service_base.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── error_interceptor.dart
│   │       └── logging_interceptor.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── date_time_utils.dart
│   │   └── string_utils.dart
│   ├── widgets/
│   │   ├── app_loading_widget.dart
│   │   ├── app_error_widget.dart
│   │   ├── custom_app_bar.dart
│   │   ├── custom_button.dart
│   │   └── custom_text_field.dart
│   ├── services/
│   │   ├── local_storage_service.dart
│   │   ├── analytics_service.dart
│   │   └── notification_service.dart
│   └── observers/
│       └── bloc_observer.dart
│
├── routes/
│   ├── app_routes.dart (route constants)
│   └── route_generator.dart (route configuration)
│
├── injection_container.dart (modular service locator)
│
└── main.dart
```

---

## File Mapping: Current → Target

### Core Files

| Current Path | Target Path | Action | Notes |
|---|---|---|---|
| `/lib/core/constants/app_constants.dart` | `/lib/core/constants/app_constants.dart` | Keep | No changes needed |
| `/lib/core/errors/exceptions.dart` | `/lib/core/error/exceptions.dart` | Move + Rename folder | Standardize folder name |
| `/lib/core/errors/failures.dart` | `/lib/core/error/failures.dart` | Move + Rename folder | Standardize folder name |
| `/lib/core/observers/bloc_observer.dart` | `/lib/core/observers/bloc_observer.dart` | Keep | No changes needed |
| `/lib/config/theme/app_theme.dart` | `/lib/core/theme/app_theme.dart` | Move | Consolidate into core |
| `/lib/core/di/injection_container.dart` | `/lib/injection_container.dart` (refactored) | Refactor | Make modular with feature registrations |
| `/lib/data/datasources/remote/dio_client.dart` | `/lib/core/network/dio_client.dart` | Move | Consolidate HTTP clients in core |
| `/lib/data/datasources/remote/interceptors/*` | `/lib/core/network/interceptors/*` | Move | Consolidate HTTP infrastructure in core |
| `/lib/data/datasources/local/local_storage.dart` | `/lib/core/services/local_storage_service.dart` | Move + Rename | Standardize service naming |
| `/lib/config/app_config.dart` | Keep at root | Keep | Environment configuration |
| `/lib/main.dart` | Keep at root | Keep | App entry point |

### Authentication Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/auth_api_service.dart` | `/lib/features/authentication/data/datasources/auth_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/auth/*` | `/lib/features/authentication/data/models/*` | Move |
| `/lib/data/repositories/auth_repository_impl.dart` | `/lib/features/authentication/data/repositories/auth_repository_impl.dart` | Move |
| `/lib/domain/repositories/auth_repository.dart` | `/lib/features/authentication/domain/repositories/auth_repository.dart` | Move |
| `/lib/domain/entities/auth_entity.dart` | `/lib/features/authentication/domain/entities/*` | Split into domain entities |
| `/lib/domain/usecases/auth_usecases.dart` | `/lib/features/authentication/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/auth/*` | `/lib/features/authentication/presentation/bloc/*` | Move |
| `/lib/presentation/pages/auth/*` | `/lib/features/authentication/presentation/pages/*` | Move |
| **NEW** | `/lib/features/authentication/presentation/widgets/*` | Create |

### Students Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/student_api_service.dart` | `/lib/features/students/data/datasources/student_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/student/student_model.dart` | `/lib/features/students/data/models/student_model.dart` | Move |
| `/lib/data/repositories/student_repository_impl.dart` | `/lib/features/students/data/repositories/student_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (StudentRepository) | `/lib/features/students/domain/repositories/student_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (StudentEntity) | `/lib/features/students/domain/entities/student_entity.dart` | Extract + Move |
| `/lib/domain/usecases/student_usecases.dart` | `/lib/features/students/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/student/*` | `/lib/features/students/presentation/bloc/*` | Move |
| `/lib/presentation/pages/` (student-related) | `/lib/features/students/presentation/pages/*` | Move + Create |
| **NEW** | `/lib/features/students/presentation/widgets/*` | Create |

### Teachers Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/teacher_api_service.dart` | `/lib/features/teachers/data/datasources/teacher_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/teacher/teacher_model.dart` | `/lib/features/teachers/data/models/teacher_model.dart` | Move |
| `/lib/data/repositories/teacher_repository_impl.dart` | `/lib/features/teachers/data/repositories/teacher_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (TeacherRepository) | `/lib/features/teachers/domain/repositories/teacher_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (TeacherEntity) | `/lib/features/teachers/domain/entities/teacher_entity.dart` | Extract + Move |
| `/lib/domain/usecases/teacher_usecases.dart` | `/lib/features/teachers/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/teacher/*` | `/lib/features/teachers/presentation/bloc/*` | Move |
| **NEW** | `/lib/features/teachers/presentation/pages/*` | Create |
| **NEW** | `/lib/features/teachers/presentation/widgets/*` | Create |

### Classes Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/class_api_service.dart` | `/lib/features/classes/data/datasources/class_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/class/class_model.dart` | `/lib/features/classes/data/models/class_model.dart` | Move |
| `/lib/data/repositories/class_repository_impl.dart` | `/lib/features/classes/data/repositories/class_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (ClassRepository) | `/lib/features/classes/domain/repositories/class_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (ClassEntity) | `/lib/features/classes/domain/entities/class_entity.dart` | Extract + Move |
| `/lib/domain/usecases/class_usecases.dart` | `/lib/features/classes/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/class/*` | `/lib/features/classes/presentation/bloc/*` | Move |
| `/lib/presentation/pages/classes_page.dart` | `/lib/features/classes/presentation/pages/classes_page.dart` | Move |
| **NEW** | `/lib/features/classes/presentation/pages/*` | Create (detail, add pages) |
| **NEW** | `/lib/features/classes/presentation/widgets/*` | Create |

### Subjects Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/subject_api_service.dart` | `/lib/features/subjects/data/datasources/subject_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/subject/subject_model.dart` | `/lib/features/subjects/data/models/subject_model.dart` | Move |
| `/lib/data/repositories/subject_repository_impl.dart` | `/lib/features/subjects/data/repositories/subject_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (SubjectRepository) | `/lib/features/subjects/domain/repositories/subject_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (SubjectEntity) | `/lib/features/subjects/domain/entities/subject_entity.dart` | Extract + Move |
| `/lib/domain/usecases/subject_usecases.dart` | `/lib/features/subjects/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/subject/*` | `/lib/features/subjects/presentation/bloc/*` | Move |
| **NEW** | `/lib/features/subjects/presentation/pages/*` | Create |
| **NEW** | `/lib/features/subjects/presentation/widgets/*` | Create |

### Attendance Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/attendance_api_service.dart` | `/lib/features/attendance/data/datasources/attendance_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/attendance/attendance_model.dart` | `/lib/features/attendance/data/models/attendance_model.dart` | Move |
| `/lib/data/repositories/attendance_repository_impl.dart` | `/lib/features/attendance/data/repositories/attendance_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (AttendanceRepository) | `/lib/features/attendance/domain/repositories/attendance_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (AttendanceEntity) | `/lib/features/attendance/domain/entities/attendance_entity.dart` | Extract + Move |
| `/lib/domain/usecases/attendance_usecases.dart` | `/lib/features/attendance/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/attendance/*` | `/lib/features/attendance/presentation/bloc/*` | Move |
| **NEW** | `/lib/features/attendance/presentation/pages/*` | Create |
| **NEW** | `/lib/features/attendance/presentation/widgets/*` | Create |

### Exams Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/exam_api_service.dart` | `/lib/features/exams/data/datasources/exam_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/exam/exam_model.dart` | `/lib/features/exams/data/models/exam_model.dart` | Move |
| `/lib/data/repositories/exam_repository_impl.dart` | `/lib/features/exams/data/repositories/exam_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (ExamRepository) | `/lib/features/exams/domain/repositories/exam_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (ExamEntity) | `/lib/features/exams/domain/entities/exam_entity.dart` | Extract + Move |
| `/lib/domain/usecases/exam_usecases.dart` | `/lib/features/exams/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/exam/*` | `/lib/features/exams/presentation/bloc/*` | Move |
| **NEW** | `/lib/features/exams/presentation/pages/*` | Create |
| **NEW** | `/lib/features/exams/presentation/widgets/*` | Create |

### Exam Results Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/exam_result_api_service.dart` | `/lib/features/exam_results/data/datasources/exam_result_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/exam_result/exam_result_model.dart` | `/lib/features/exam_results/data/models/exam_result_model.dart` | Move |
| `/lib/data/repositories/exam_result_repository_impl.dart` | `/lib/features/exam_results/data/repositories/exam_result_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (ExamResultRepository) | `/lib/features/exam_results/domain/repositories/exam_result_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (ExamResultEntity) | `/lib/features/exam_results/domain/entities/exam_result_entity.dart` | Extract + Move |
| `/lib/domain/usecases/exam_result_usecases.dart` | `/lib/features/exam_results/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/exam_result/*` | `/lib/features/exam_results/presentation/bloc/*` | Move |
| **NEW** | `/lib/features/exam_results/presentation/pages/*` | Create |
| **NEW** | `/lib/features/exam_results/presentation/widgets/*` | Create |

### Parent Feature

| Current Path | Target Path | Files |
|---|---|---|
| `/lib/data/datasources/remote/api_services/parent_api_service.dart` | `/lib/features/parents/data/datasources/parent_remote_datasource.dart` | Move + Rename |
| `/lib/data/models/parent/parent_model.dart` | `/lib/features/parents/data/models/parent_model.dart` | Move |
| `/lib/data/repositories/parent_repository_impl.dart` | `/lib/features/parents/data/repositories/parent_repository_impl.dart` | Move |
| `/lib/domain/repositories/` (ParentRepository) | `/lib/features/parents/domain/repositories/parent_repository.dart` | Extract + Move |
| `/lib/domain/entities/` (ParentEntity) | `/lib/features/parents/domain/entities/parent_entity.dart` | Extract + Move |
| `/lib/domain/usecases/parent_usecases.dart` | `/lib/features/parents/domain/usecases/*.dart` | Split into individual usecases |
| `/lib/presentation/bloc/parent/*` | `/lib/features/parents/presentation/bloc/*` | Move |
| **NEW** | `/lib/features/parents/presentation/pages/*` | Create |
| **NEW** | `/lib/features/parents/presentation/widgets/*` | Create |

### Routing Refactoring

| Current Path | Target Path | Changes |
|---|---|---|
| `/lib/config/routes/router.dart` | `/lib/routes/app_routes.dart` | Extract route constants and path definitions |
| **NEW** | `/lib/routes/route_generator.dart` | Create GoRouter configuration with feature routes |
| `/lib/config/app_config.dart` | Keep at root | Environment config (no changes) |

### New Features (No Current Implementation)

The following features require complete new implementation:

- **Fees** - `/lib/features/fees/` (complete structure)
- **Timetable** - `/lib/features/timetable/` (complete structure)
- **Library** - `/lib/features/library/` (complete structure)
- **Transport** - `/lib/features/transport/` (complete structure)
- **Hostel** - `/lib/features/hostel/` (complete structure)
- **Payroll** - `/lib/features/payroll/` (complete structure)
- **Reports** - `/lib/features/reports/` (complete structure)
- **Notifications** - `/lib/features/notifications/` (complete structure)
- **Dashboard** - Split `/lib/features/dashboard/` (move from presentation pages)

---

## Refactoring Phases

### Phase 1: Core Infrastructure Setup (Foundation)
**Duration**: 1-2 days
**Goal**: Prepare core modules and set up the feature-based structure

1. **Reorganize Core:**
   - Create `/lib/core/error/` and move exceptions/failures
   - Move theme to `/lib/core/theme/`
   - Move HTTP infrastructure to `/lib/core/network/`
   - Create `/lib/core/utils/`, `/lib/core/widgets/`, `/lib/core/services/`
   - Create new `/lib/routes/` for routing

2. **Create Base Files:**
   - Create modular `/lib/injection_container.dart`
   - Create `/lib/routes/app_routes.dart` with route constants
   - Create `/lib/routes/route_generator.dart` with GoRouter config
   - Create `feature_injection_mixin.dart` for each feature DI

3. **Update main.dart:**
   - Update imports to new paths
   - Update route configuration

**Files to Create**: ~15 new files
**Files to Move**: ~20 files
**Files to Refactor**: 3-5 files

---

### Phase 2: Core Features Migration (High Priority)
**Duration**: 2-3 days
**Goal**: Migrate most-used features

**Order**: Authentication → Dashboard → Students → Classes

1. **Authentication Feature:**
   - Create feature directory structure
   - Move API service → datasources
   - Move models, entities, usecases
   - Move repository implementations
   - Move bloc, pages, create widgets
   - Create `features/authentication/injection_container.dart`
   - Update imports across feature

2. **Dashboard Feature:**
   - Similar to authentication
   - Move pages and create widgets

3. **Students Feature:**
   - Similar to authentication
   - Consider dependencies on other entities

4. **Classes Feature:**
   - Similar to authentication
   - Handle cross-feature entity references

**Files to Move**: ~60 files
**Files to Create**: ~30 files (new widgets, separated usecases)
**Files to Refactor**: ~40 files (import updates)

---

### Phase 3: Secondary Features Migration (Medium Priority)
**Duration**: 2-3 days
**Goal**: Migrate remaining implemented features

**Order**: Teachers → Subjects → Attendance → Exams → ExamResults

1. **Teachers Feature**
2. **Subjects Feature**
3. **Attendance Feature**
4. **Exams Feature**
5. **ExamResults Feature**

**Files to Move**: ~50 files
**Files to Create**: ~25 files
**Files to Refactor**: ~35 files

---

### Phase 4: Additional Features Migration (Lower Priority)
**Duration**: 1 day
**Goal**: Migrate parent/guardian feature

1. **Parent Feature** - Similar migration process

**Files to Move**: ~10 files
**Files to Create**: ~5 files
**Files to Refactor**: ~8 files

---

### Phase 5: New Features Scaffolding (Future Implementation)
**Duration**: 1 day
**Goal**: Create directory structures for future features

Create complete (but empty) feature structures for:
- Fees
- Timetable
- Library
- Transport
- Hostel
- Payroll
- Reports
- Notifications

Each with:
- `/data/datasources/`, `/models/`, `/repositories/`
- `/domain/entities/`, `/repositories/`, `/usecases/`
- `/presentation/bloc/`, `/pages/`, `/widgets/`
- `injection_container.dart` template

---

### Phase 6: Testing & Integration (Validation)
**Duration**: 1-2 days
**Goal**: Verify refactoring correctness

1. Run all tests
2. Fix import issues
3. Test app startup
4. Verify routes work
5. Verify DI resolution

---

## Key Considerations for Implementation

### 1. Import Path Changes Strategy

**Current Pattern:**
```dart
import 'package:school_management/domain/repositories/student_repository.dart';
import 'package:school_management/data/repositories/student_repository_impl.dart';
```

**New Pattern:**
```dart
import 'package:school_management/features/students/domain/repositories/student_repository.dart';
import 'package:school_management/features/students/data/repositories/student_repository_impl.dart';
```

**Action Plan:**
- Use IDE's "Refactor → Move" feature when available
- Manual find-replace for recurring patterns
- Review cross-feature imports
- Update pubspec.yaml if using package imports

### 2. Cross-Feature Dependencies

**Example**: Students depend on Classes

**Solution**:
```dart
// In students feature
import 'package:school_management/features/classes/domain/entities/class_entity.dart';

// Export from domain
export 'package:school_management/features/classes/domain/entities/class_entity.dart';
```

**Guidelines**:
- Only import from public APIs (repositories, entities, usecases)
- Never import from another feature's data layer
- Avoid circular dependencies
- Consider facade patterns for complex feature interactions

### 3. Shared Models Handling

**Issue**: Some models (e.g., StudentEntity) may be referenced by multiple features

**Solutions**:
1. **Duplicated entities** - Each feature has its own entity (recommended for independence)
2. **Shared entities in core** - Not recommended (violates feature isolation)
3. **Wrapper entities** - Maps between features' entities as needed

**Recommendation**: Use approach #1 with careful documentation

### 4. Dependency Injection Refactoring

**Current Pattern** (monolithic):
```dart
// lib/core/di/injection_container.dart
setupServiceLocator() {
  // All 100+ registrations here
}
```

**New Pattern** (modular):
```dart
// lib/injection_container.dart
Future<void> setupServiceLocator() async {
  // Core infrastructure
  await _setupCoreServices();
  
  // Features (lazy loading possible)
  await AuthenticationModule.register();
  await StudentsModule.register();
  // ... etc
}

// lib/features/authentication/injection_container.dart
class AuthenticationModule {
  static Future<void> register() async {
    final getIt = GetIt.instance;
    // Feature-specific registrations
  }
}
```

### 5. Route Configuration Refactoring

**Current Pattern**:
```dart
// Single router file with all routes
final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/login', ...),
    GoRoute(path: '/students', ...),
    // ... 50+ routes mixed
  ],
);
```

**New Pattern**:
```dart
// lib/routes/route_generator.dart
GoRouter createRouter() {
  return GoRouter(
    routes: [
      ...authenticationRoutes(),
      ...studentRoutes(),
      ...teacherRoutes(),
      // ... feature routes
    ],
  );
}

// lib/features/authentication/routes/auth_routes.dart
List<GoRoute> authenticationRoutes() {
  return [
    GoRoute(path: '/login', ...),
    GoRoute(path: '/register', ...),
  ];
}

// lib/features/students/routes/student_routes.dart
List<GoRoute> studentRoutes() {
  return [
    GoRoute(path: '/students', ...),
    GoRoute(path: '/students/:id', ...),
  ];
}
```

---

## Summary of Changes

### Total Files Impact

| Action | Count | Notes |
|--------|-------|-------|
| **Move** | ~140 | Existing files to new feature locations |
| **Create** | ~120 | New widgets, pages, separated usecases, new features |
| **Refactor** | ~60 | Import updates, DI changes |
| **Delete** | ~20 | Old consolidated files (all_repositories.dart, etc.) |
| **Keep** | ~10 | main.dart, app_config.dart, etc. |

### Benefits After Refactoring

1. **Modularity**: Each feature can be developed independently
2. **Scalability**: Easy to add new features without touching existing code
3. **Testability**: Features can be tested in isolation
4. **Reusability**: Features can be extracted into separate packages
5. **Maintainability**: Clear folder structure mirrors business domain
6. **Team Collaboration**: Multiple developers can work on features simultaneously
7. **Performance**: Lazy loading of features becomes possible
8. **Code Organization**: Self-documenting file structure

### Architecture Principles Achieved

✓ **Single Responsibility**: Each feature handles its own domain
✓ **Open/Closed**: Open for extension (new features), closed for modification
✓ **Dependency Inversion**: Depend on abstractions (repositories, usecases)
✓ **Clean Boundaries**: Clear data layer → domain layer → presentation layer
✓ **Minimal Coupling**: Features couple only through well-defined interfaces
✓ **Feature Autonomy**: Features don't know about each other's internal structure

---

## Post-Refactoring Tasks

1. **Documentation Update**:
   - Update README with new structure
   - Document feature development guidelines
   - Create architecture documentation

2. **Development Guidelines**:
   - Create feature template with boilerplate
   - Document when to split usecases
   - Define widget organization within features

3. **Build Optimization**:
   - Implement lazy loading for features (if using modular_app_flutter)
   - Consider code splitting for large features

4. **Testing Strategy**:
   - Update test file organization to mirror source
   - Create test fixtures for each feature
   - Integration tests for feature interactions

5. **CI/CD Updates**:
   - Update build scripts if needed
   - Ensure tests run correctly with new structure

---

## Potential Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| **Circular imports** | Use barrel files (*.dart), careful module boundaries |
| **Shared entities** | Create mappers between features, document dependencies |
| **Large migration** | Phase-based approach, automated tools where possible |
| **Team coordination** | Clear feature assignments, documented conventions |
| **Performance regression** | Profile before/after, lazy load features if needed |
| **Testing complexity** | Unit test features in isolation, integration tests for flows |

---

## Conclusion

This refactoring transforms the application from a monolithic clean architecture into a scalable feature-based modular architecture. The phased approach allows for incremental implementation while maintaining app stability. The new structure enables better code organization, easier feature development, and improved team collaboration.

**Estimated Total Duration**: 7-10 days for complete implementation

**Immediate Next Steps**:
1. Review this plan with the team
2. Set up Phase 1 core infrastructure
3. Begin Phase 2 with authentication feature
4. Adjust timeline based on actual progress
