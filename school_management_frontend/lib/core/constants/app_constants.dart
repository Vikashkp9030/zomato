class AppConstants {
  // App Info
  static const String appName = 'School Management';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';
  static const String isLoggedInKey = 'is_logged_in';

  // API Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authProfile = '/profile';
  static const String changePassword = '/change-password';

  // Classes Endpoints
  static const String getAllClasses = '/classes';
  static const String getClassById = '/classes/{id}';
  static const String createClass = '/classes';
  static const String updateClass = '/classes/{id}';
  static const String deleteClass = '/classes/{id}';
  static const String getClassInfo = '/classes/{id}/info';
  static const String getClassesByGrade = '/grade-levels/{grade_level}/classes';

  // Teachers Endpoints
  static const String getAllTeachers = '/teachers';
  static const String getTeacherById = '/teachers/{id}';
  static const String createTeacher = '/teachers';
  static const String updateTeacher = '/teachers/{id}';
  static const String deleteTeacher = '/teachers/{id}';
  static const String getTeacherClasses = '/teachers/{id}/classes';
  static const String getTeachersBySpecialization = '/teachers/specialization';

  // Subjects Endpoints
  static const String getAllSubjects = '/subjects';
  static const String getSubjectById = '/subjects/{id}';
  static const String createSubject = '/subjects';
  static const String updateSubject = '/subjects/{id}';
  static const String deleteSubject = '/subjects/{id}';
  static const String searchSubjects = '/subjects/search';

  // Students Endpoints
  static const String getAllStudents = '/students';
  static const String getStudentById = '/students/{id}';
  static const String createStudent = '/students';
  static const String updateStudent = '/students/{id}';
  static const String deleteStudent = '/students/{id}';
  static const String getStudentPerformance = '/students/{id}/performance';
  static const String getStudentsByClass = '/classes/{class_id}/students';

  // Exams Endpoints
  static const String getAllExams = '/exams';
  static const String getExamById = '/exams/{id}';
  static const String createExam = '/exams';
  static const String updateExam = '/exams/{id}';
  static const String deleteExam = '/exams/{id}';
  static const String getUpcomingExams = '/exams/upcoming';
  static const String getExamsByClass = '/classes/{class_id}/exams';

  // Exam Results Endpoints
  static const String createExamResult = '/exam-results';
  static const String getExamResult = '/exam-results/{id}';
  static const String updateExamResult = '/exam-results/{id}';
  static const String deleteExamResult = '/exam-results/{id}';
  static const String getExamResults = '/exams/{exam_id}/results';
  static const String getExamStats = '/exams/{exam_id}/results/stats';
  static const String getStudentResults = '/students/{student_id}/results';
  static const String getStudentGPA = '/students/{student_id}/gpa';

  // Attendance Endpoints
  static const String createAttendance = '/attendance';
  static const String getAttendance = '/attendance/{id}';
  static const String updateAttendance = '/attendance/{id}';
  static const String deleteAttendance = '/attendance/{id}';
  static const String getStudentAttendance = '/students/{student_id}/attendance';
  static const String getAttendanceSummary = '/students/{student_id}/attendance/summary';
  static const String getClassAttendance = '/classes/{class_id}/attendance';

  // Parents Endpoints
  static const String getAllParents = '/parents';
  static const String getParentById = '/parents/{id}';
  static const String createParent = '/parents';
  static const String updateParent = '/parents/{id}';
  static const String deleteParent = '/parents/{id}';
  static const String getStudentParents = '/students/{student_id}/parents';
  static const String searchParentsByEmail = '/parents/email';
  static const String searchParentsByPhone = '/parents/phone';

  // Error Messages
  static const String connectionError = 'Connection error. Please check your internet.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Unknown error occurred. Please try again.';

  // Pagination
  static const int defaultPageSize = 10;
  static const int defaultPage = 1;

  // Durations
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration dialogDismissDuration = Duration(seconds: 2);
}
