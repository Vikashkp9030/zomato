import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'core/services/app_config.dart';
import 'core/services/local_storage.dart';
import 'core/network/dio_client.dart';
import 'features/authentication/data/datasources/auth_api_service.dart';
import 'features/classes/data/datasources/class_api_service.dart';
import 'features/teachers/data/datasources/teacher_api_service.dart';
import 'features/subjects/data/datasources/subject_api_service.dart';
import 'features/students/data/datasources/student_api_service.dart';
import 'features/exams/data/datasources/exam_api_service.dart';
import 'features/exam_results/data/datasources/exam_result_api_service.dart';
import 'features/attendance/data/datasources/attendance_api_service.dart';
import 'features/parents/data/datasources/parent_api_service.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/classes/data/repositories/class_repository_impl.dart';
import 'features/teachers/data/repositories/teacher_repository_impl.dart';
import 'features/subjects/data/repositories/subject_repository_impl.dart';
import 'features/students/data/repositories/student_repository_impl.dart';
import 'features/exams/data/repositories/exam_repository_impl.dart';
import 'features/exam_results/data/repositories/exam_result_repository_impl.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/parents/data/repositories/parent_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/classes/domain/repositories/class_repository.dart';
import 'features/teachers/domain/repositories/teacher_repository.dart';
import 'features/subjects/domain/repositories/subject_repository.dart';
import 'features/students/domain/repositories/student_repository.dart';
import 'features/exams/domain/repositories/exam_repository.dart';
import 'features/exam_results/domain/repositories/exam_result_repository.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/parents/domain/repositories/parent_repository.dart';
import 'features/authentication/domain/usecases/auth_usecases.dart';
import 'features/classes/domain/usecases/class_usecases.dart';
import 'features/teachers/domain/usecases/teacher_usecases.dart';
import 'features/subjects/domain/usecases/subject_usecases.dart';
import 'features/students/domain/usecases/student_usecases.dart';
import 'features/exams/domain/usecases/exam_usecases.dart';
import 'features/exam_results/domain/usecases/exam_result_usecases.dart';
import 'features/attendance/domain/usecases/attendance_usecases.dart';
import 'features/parents/domain/usecases/parent_usecases.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/classes/presentation/bloc/class_bloc.dart';
import 'features/teachers/presentation/bloc/teacher_bloc.dart';
import 'features/subjects/presentation/bloc/subject_bloc.dart';
import 'features/students/presentation/bloc/student_bloc.dart';
import 'features/exams/presentation/bloc/exam_bloc.dart';
import 'features/exam_results/presentation/bloc/exam_result_bloc.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';
import 'features/parents/presentation/bloc/parent_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_api_service.dart';
import 'features/timetable/data/datasources/timetable_api_service.dart';
import 'features/fees/data/datasources/fees_api_service.dart';
import 'features/transport/data/datasources/transport_api_service.dart';
import 'features/hostel/data/datasources/hostel_api_service.dart';
import 'features/library/data/datasources/library_api_service.dart';
import 'features/notifications/data/datasources/notifications_api_service.dart';
import 'features/payroll/data/datasources/payroll_api_service.dart';
import 'features/reports/data/datasources/reports_api_service.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/fees/data/repositories/fees_repository_impl.dart';
import 'features/fees/domain/repositories/fees_repository.dart';
import 'features/fees/domain/usecases/fees_usecases.dart';
import 'features/fees/presentation/bloc/fees_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Local Storage (Initialize first)
  final localStorage = LocalStorage();
  await localStorage.init();
  getIt.registerSingleton<LocalStorage>(localStorage);

  // HTTP Client with proper web support
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  // Log base URL configuration
  print('🌐 API Base URL: ${AppConfig.baseUrl}');
  print('🖥️  Platform: ${kIsWeb ? 'Web' : 'Mobile'}');

  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<DioClient>(DioClient(dio, localStorage));

  // API Services - Core Modules
  getIt.registerSingleton<AuthApiService>(AuthApiService(getIt<DioClient>()));
  getIt.registerSingleton<ClassApiService>(ClassApiService(getIt<DioClient>()));
  getIt.registerSingleton<TeacherApiService>(TeacherApiService(getIt<DioClient>()));
  getIt.registerSingleton<SubjectApiService>(SubjectApiService(getIt<DioClient>()));
  getIt.registerSingleton<StudentApiService>(StudentApiService(getIt<DioClient>()));
  getIt.registerSingleton<ExamApiService>(ExamApiService(getIt<DioClient>()));
  getIt.registerSingleton<ExamResultApiService>(ExamResultApiService(getIt<DioClient>()));
  getIt.registerSingleton<AttendanceApiService>(AttendanceApiService(getIt<DioClient>()));
  getIt.registerSingleton<ParentApiService>(ParentApiService(getIt<DioClient>()));

  // API Services - Phase 2 Modules
  getIt.registerSingleton<DashboardApiService>(DashboardApiService(getIt<DioClient>()));
  getIt.registerSingleton<TimetableApiService>(TimetableApiService(getIt<DioClient>()));
  getIt.registerSingleton<FeesApiService>(FeesApiService(getIt<DioClient>()));
  getIt.registerSingleton<TransportApiService>(TransportApiService(getIt<DioClient>()));
  getIt.registerSingleton<HostelApiService>(HostelApiService(getIt<DioClient>()));
  getIt.registerSingleton<LibraryApiService>(LibraryApiService(getIt<DioClient>()));
  getIt.registerSingleton<NotificationsApiService>(NotificationsApiService(getIt<DioClient>()));
  getIt.registerSingleton<PayrollApiService>(PayrollApiService(getIt<DioClient>()));
  getIt.registerSingleton<ReportsApiService>(ReportsApiService(getIt<DioClient>()));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<AuthApiService>(), getIt<LocalStorage>()),
  );
  getIt.registerSingleton<ClassRepository>(
    ClassRepositoryImpl(getIt<ClassApiService>()),
  );
  getIt.registerSingleton<TeacherRepository>(
    TeacherRepositoryImpl(getIt<TeacherApiService>()),
  );
  getIt.registerSingleton<SubjectRepository>(
    SubjectRepositoryImpl(getIt<SubjectApiService>()),
  );
  getIt.registerSingleton<StudentRepository>(
    StudentRepositoryImpl(getIt<StudentApiService>()),
  );
  getIt.registerSingleton<ExamRepository>(
    ExamRepositoryImpl(getIt<ExamApiService>()),
  );
  getIt.registerSingleton<ExamResultRepository>(
    ExamResultRepositoryImpl(getIt<ExamResultApiService>()),
  );
  getIt.registerSingleton<AttendanceRepository>(
    AttendanceRepositoryImpl(getIt<AttendanceApiService>()),
  );
  getIt.registerSingleton<ParentRepository>(
    ParentRepositoryImpl(getIt<ParentApiService>()),
  );

  // UseCases
  getIt.registerSingleton<AuthUseCases>(AuthUseCases(getIt<AuthRepository>()));
  getIt.registerSingleton<ClassUseCases>(ClassUseCases(getIt<ClassRepository>()));
  getIt.registerSingleton<TeacherUseCases>(TeacherUseCases(getIt<TeacherRepository>()));
  getIt.registerSingleton<SubjectUseCases>(SubjectUseCases(getIt<SubjectRepository>()));
  getIt.registerSingleton<StudentUseCases>(StudentUseCases(getIt<StudentRepository>()));
  getIt.registerSingleton<ExamUseCases>(ExamUseCases(getIt<ExamRepository>()));
  getIt.registerSingleton<ExamResultUseCases>(ExamResultUseCases(getIt<ExamResultRepository>()));
  getIt.registerSingleton<AttendanceUseCases>(AttendanceUseCases(getIt<AttendanceRepository>()));
  getIt.registerSingleton<ParentUseCases>(ParentUseCases(getIt<ParentRepository>()));

  // Repositories - Phase 2
  getIt.registerSingleton<DashboardRepository>(
    DashboardRepositoryImpl(getIt<DashboardApiService>()),
  );
  getIt.registerSingleton<FeesRepository>(
    FeesRepositoryImpl(getIt<FeesApiService>()),
  );

  // UseCases - Phase 2
  getIt.registerSingleton<DashboardUseCases>(
    DashboardUseCases(getIt<DashboardRepository>()),
  );
  getIt.registerSingleton<FeesUseCases>(
    FeesUseCases(getIt<FeesRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(AuthBloc(getIt<AuthUseCases>()));
  getIt.registerSingleton<ClassBloc>(ClassBloc(getIt<ClassUseCases>()));
  getIt.registerSingleton<TeacherBloc>(TeacherBloc(getIt<TeacherUseCases>()));
  getIt.registerSingleton<SubjectBloc>(SubjectBloc(getIt<SubjectUseCases>()));
  getIt.registerSingleton<StudentBloc>(StudentBloc(getIt<StudentUseCases>()));
  getIt.registerSingleton<ExamBloc>(ExamBloc(getIt<ExamUseCases>()));
  getIt.registerSingleton<ExamResultBloc>(ExamResultBloc(getIt<ExamResultUseCases>()));
  getIt.registerSingleton<AttendanceBloc>(AttendanceBloc(getIt<AttendanceUseCases>()));
  getIt.registerSingleton<ParentBloc>(ParentBloc(getIt<ParentUseCases>()));
  getIt.registerSingleton<DashboardBloc>(DashboardBloc(getIt<DashboardUseCases>()));
  getIt.registerSingleton<FeesBloc>(FeesBloc(getIt<FeesUseCases>()));
}

