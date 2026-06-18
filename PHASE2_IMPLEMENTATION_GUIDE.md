# Phase 2 Implementation Guide - School Management System

## Overview
This guide provides step-by-step instructions to complete the implementation of Phase 2 modules (Dashboard, Timetable, Fees, Transport, Hostel, Library, Notifications, Payroll, Reports).

---

## ✅ What's Already Done

### Backend
- ✅ All data models created in Go
- ✅ Dashboard handler created (example)
- ✅ Base structure for repositories and handlers

### Frontend
- ✅ All API services created for Phase 2 modules
- ✅ Dependency injection updated
- ✅ Dashboard repository implementation created (example)
- ✅ Error handling setup
- ✅ Auth types fixed

---

## 📋 Step-by-Step Implementation

### STEP 1: Create Domain Repositories (Interface)

For each module, create the repository interface:

**Example: Dashboard**
```dart
// lib/features/dashboard/domain/repositories/dashboard_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
  Future<Either<Failure, List<dynamic>>> getWeeklyAttendance();
  Future<Either<Failure, List<dynamic>>> getClassPerformance();
  Future<Either<Failure, List<dynamic>>> getUpcomingExams();
  Future<Either<Failure, List<dynamic>>> getPendingFees();
  Future<Either<Failure, List<dynamic>>> getNotifications();
}
```

**Pattern to follow for other modules:**
```dart
abstract class {Module}Repository {
  Future<Either<Failure, {ReturnType}>> method1();
  Future<Either<Failure, {ReturnType}>> method2();
  // ... more methods
}
```

---

### STEP 2: Create Use Cases

**Example: Dashboard UseCases**
```dart
// lib/features/dashboard/domain/usecases/dashboard_usecases.dart

import 'package:dartz/dartz.dart';
import '../repositories/dashboard_repository.dart';
import '../../../../core/error/failures.dart';

class DashboardUseCases {
  final DashboardRepository repository;

  DashboardUseCases(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    return await repository.getDashboardStats();
  }

  Future<Either<Failure, List<dynamic>>> getWeeklyAttendance() async {
    return await repository.getWeeklyAttendance();
  }

  Future<Either<Failure, List<dynamic>>> getClassPerformance() async {
    return await repository.getClassPerformance();
  }

  Future<Either<Failure, List<dynamic>>> getUpcomingExams() async {
    return await repository.getUpcomingExams();
  }

  Future<Either<Failure, List<dynamic>>> getPendingFees() async {
    return await repository.getPendingFees();
  }

  Future<Either<Failure, List<dynamic>>> getNotifications() async {
    return await repository.getNotifications();
  }
}
```

---

### STEP 3: Create BLoCs (Events, States)

**Example: Dashboard Events**
```dart
// lib/features/dashboard/presentation/bloc/dashboard_event.dart

import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboardStatsEvent extends DashboardEvent {
  const FetchDashboardStatsEvent();
}

class FetchWeeklyAttendanceEvent extends DashboardEvent {
  const FetchWeeklyAttendanceEvent();
}

class FetchClassPerformanceEvent extends DashboardEvent {
  const FetchClassPerformanceEvent();
}

// ... more events
```

**Example: Dashboard States**
```dart
// lib/features/dashboard/presentation/bloc/dashboard_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../../core/error/failures.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardStatsLoadedState extends DashboardState {
  final Map<String, dynamic> stats;

  const DashboardStatsLoadedState({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
```

**Example: Dashboard BLoC**
```dart
// lib/features/dashboard/presentation/bloc/dashboard_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCases useCases;
  final Logger _logger = Logger();

  DashboardBloc(this.useCases) : super(const DashboardInitialState()) {
    on<FetchDashboardStatsEvent>(_onFetchStats);
    on<FetchWeeklyAttendanceEvent>(_onFetchWeeklyAttendance);
    on<FetchClassPerformanceEvent>(_onFetchClassPerformance);
  }

  Future<void> _onFetchStats(
    FetchDashboardStatsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getDashboardStats();
    result.fold(
      (failure) => emit(DashboardErrorState(message: failure.message)),
      (stats) => emit(DashboardStatsLoadedState(stats: stats)),
    );
  }

  Future<void> _onFetchWeeklyAttendance(
    FetchWeeklyAttendanceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getWeeklyAttendance();
    result.fold(
      (failure) => emit(DashboardErrorState(message: failure.message)),
      (data) => emit(DashboardStatsLoadedState(stats: {'attendance': data})),
    );
  }

  Future<void> _onFetchClassPerformance(
    FetchClassPerformanceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());
    final result = await useCases.getClassPerformance();
    result.fold(
      (failure) => emit(DashboardErrorState(message: failure.message)),
      (data) => emit(DashboardStatsLoadedState(stats: {'performance': data})),
    );
  }
}
```

---

### STEP 4: Update Injection Container

Add to `lib/injection_container.dart`:

```dart
// Repository Imports
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

// ... In setupServiceLocator function

// Repositories
getIt.registerSingleton<DashboardRepository>(
  DashboardRepositoryImpl(getIt<DashboardApiService>()),
);

// UseCases
getIt.registerSingleton<DashboardUseCases>(
  DashboardUseCases(getIt<DashboardRepository>()),
);

// BLoCs
getIt.registerSingleton<DashboardBloc>(
  DashboardBloc(getIt<DashboardUseCases>()),
);
```

---

### STEP 5: Create Backend Routes

Update `internal/routes/routes.go`:

```go
// Dashboard
protected.HandleFunc("/dashboard/stats", dashboardHandler.GetStats).Methods("GET")
protected.HandleFunc("/dashboard/attendance/weekly", dashboardHandler.GetWeeklyAttendance).Methods("GET")
protected.HandleFunc("/dashboard/performance", dashboardHandler.GetPerformance).Methods("GET")
protected.HandleFunc("/dashboard/exams/upcoming", dashboardHandler.GetUpcomingExams).Methods("GET")
protected.HandleFunc("/dashboard/fees/pending", dashboardHandler.GetPendingFees).Methods("GET")
protected.HandleFunc("/dashboard/notifications", dashboardHandler.GetNotifications).Methods("GET")
```

---

### STEP 6: Create UI Screens

**Example Dashboard Screen:**
```dart
// lib/features/dashboard/presentation/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchDashboardStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is DashboardErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          
          if (state is DashboardStatsLoadedState) {
            final stats = state.stats;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatCard(
                  'Total Students',
                  stats['total_students']?.toString() ?? '0',
                  Colors.blue,
                ),
                _buildStatCard(
                  'Total Teachers',
                  stats['total_teachers']?.toString() ?? '0',
                  Colors.green,
                ),
                _buildStatCard(
                  'Total Classes',
                  stats['total_classes']?.toString() ?? '0',
                  Colors.orange,
                ),
              ],
            );
          }
          
          return const Center(child: Text('No data'));
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 30,
              child: const Icon(Icons.people, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey)),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📋 Module Implementation Checklist

### For Each Phase 2 Module:

- [ ] **Create Domain Layer**
  - [ ] Create repository interface
  - [ ] Create entities (if needed)
  - [ ] Create use cases

- [ ] **Create Data Layer**
  - [ ] API service (✅ Already created)
  - [ ] Model classes
  - [ ] Repository implementation

- [ ] **Create Presentation Layer**
  - [ ] Events
  - [ ] States
  - [ ] BLoCs
  - [ ] Pages/Screens
  - [ ] Widgets

- [ ] **Backend Implementation**
  - [ ] Create models
  - [ ] Create repository (if complex)
  - [ ] Create handlers
  - [ ] Register routes
  - [ ] Database migrations

- [ ] **Integration**
  - [ ] Update injection container
  - [ ] Add navigation routes
  - [ ] Connect to main app

---

## 🚀 Priority Order

1. **Dashboard** - Core analytics (START HERE)
2. **Timetable** - Class scheduling
3. **Fees** - Payment management
4. **Transport** - Student transport
5. **Hostel** - Accommodation
6. **Notifications** - Alert system
7. **Library** - Book management
8. **Payroll** - Employee salaries
9. **Reports** - Data export

---

## 📝 Backend Repository Interface Template

```go
// internal/repository/dashboard_repo.go

package repository

type DashboardRepository interface {
	GetStudentCount() (int, error)
	GetTeacherCount() (int, error)
	GetClassCount() (int, error)
	GetUpcomingExamCount() (int, error)
	GetAverageAttendance() (float64, error)
	GetPendingFeesTotal() (float64, error)
}
```

---

## 🔗 Integration Steps

1. **Create all domain layers first** (faster, interfaces are stable)
2. **Create data layer** (use existing API services)
3. **Create presentation layer** (BLoCs and UI)
4. **Create backend handlers** (following Go patterns)
5. **Register routes**
6. **Test and integrate**

---

## 💡 Tips

- Use the Dashboard implementation as a template for other modules
- Follow the established patterns (BLoC architecture, error handling)
- Test each module independently before integration
- Use the logging already setup for debugging
- Keep API services lightweight (just HTTP calls)
- Handle edge cases in repositories

---

## 📞 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Type errors in BLoCs | Ensure state/event classes are properly typed |
| API not found | Check routes are registered in backend |
| DI errors | Ensure all dependencies are registered |
| UI not updating | Ensure BLoC is properly emitting states |
| CORS errors | Check CORS middleware in Go backend |

---

## ✨ Next Steps

1. Copy this entire guide
2. Follow it step-by-step for Dashboard (already has skeleton)
3. Then apply the same pattern for remaining 8 modules
4. Test thoroughly before moving to next module

**Estimated time to complete all modules: 2-3 days**

Good luck! 🚀