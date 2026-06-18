import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/pages/splash_page.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../features/authentication/presentation/pages/register_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/students/presentation/pages/students_list_page.dart';
import '../features/students/presentation/pages/student_detail_page.dart';
import '../features/teachers/presentation/pages/teachers_list_page.dart';
import '../features/teachers/presentation/pages/teacher_detail_page.dart';
import '../features/exams/presentation/pages/exams_list_page.dart';
import '../features/exams/presentation/pages/exam_detail_page.dart';
import '../features/classes/presentation/pages/classes_list_page.dart';
import '../features/classes/presentation/pages/class_detail_page.dart';

class AppRouter {
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String classesRoute = '/classes';
  static const String teachersRoute = '/teachers';
  static const String subjectsRoute = '/subjects';
  static const String studentsRoute = '/students';
  static const String examsRoute = '/exams';
  static const String resultsRoute = '/results';
  static const String attendanceRoute = '/attendance';
  static const String parentsRoute = '/parents';
  static const String profileRoute = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: loginRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: registerRoute,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: dashboardRoute,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: studentsRoute,
        builder: (context, state) => const StudentsListPage(),
        routes: [
          GoRoute(
            path: ':studentId',
            builder: (context, state) => StudentDetailPage(
              studentId: state.pathParameters['studentId']!,
            ),
          ),
          GoRoute(
            path: 'create',
            builder: (context, state) => const PlaceholderPage(title: 'Create Student'),
          ),
          GoRoute(
            path: ':studentId/edit',
            builder: (context, state) => const PlaceholderPage(title: 'Edit Student'),
          ),
        ],
      ),
      GoRoute(
        path: teachersRoute,
        builder: (context, state) => const TeachersListPage(),
        routes: [
          GoRoute(
            path: ':teacherId',
            builder: (context, state) => TeacherDetailPage(
              teacherId: state.pathParameters['teacherId']!,
            ),
          ),
          GoRoute(
            path: 'create',
            builder: (context, state) => const PlaceholderPage(title: 'Create Teacher'),
          ),
          GoRoute(
            path: ':teacherId/edit',
            builder: (context, state) => const PlaceholderPage(title: 'Edit Teacher'),
          ),
        ],
      ),
      GoRoute(
        path: examsRoute,
        builder: (context, state) => const ExamsListPage(),
        routes: [
          GoRoute(
            path: ':examId',
            builder: (context, state) => ExamDetailPage(
              examId: state.pathParameters['examId']!,
            ),
          ),
          GoRoute(
            path: 'create',
            builder: (context, state) => const PlaceholderPage(title: 'Create Exam'),
          ),
          GoRoute(
            path: ':examId/edit',
            builder: (context, state) => const PlaceholderPage(title: 'Edit Exam'),
          ),
        ],
      ),
      GoRoute(
        path: classesRoute,
        builder: (context, state) => const ClassesListPage(),
        routes: [
          GoRoute(
            path: ':classId',
            builder: (context, state) => ClassDetailPage(
              classId: state.pathParameters['classId']!,
            ),
          ),
          GoRoute(
            path: 'create',
            builder: (context, state) => const PlaceholderPage(title: 'Create Class'),
          ),
          GoRoute(
            path: ':classId/edit',
            builder: (context, state) => const PlaceholderPage(title: 'Edit Class'),
          ),
        ],
      ),
      GoRoute(
        path: subjectsRoute,
        builder: (context, state) => const PlaceholderPage(title: 'Subjects'),
      ),
      GoRoute(
        path: resultsRoute,
        builder: (context, state) => const PlaceholderPage(title: 'Results'),
      ),
      GoRoute(
        path: attendanceRoute,
        builder: (context, state) => const PlaceholderPage(title: 'Attendance'),
      ),
      GoRoute(
        path: parentsRoute,
        builder: (context, state) => const PlaceholderPage(title: 'Parents'),
      ),
      GoRoute(
        path: profileRoute,
        builder: (context, state) => const PlaceholderPage(title: 'Profile'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text('Page not found'),
      ),
    ),
  );
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Page',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Coming Soon'),
          ],
        ),
      ),
    );
  }
}
