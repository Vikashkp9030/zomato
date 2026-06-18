# Quick Reference Guide

## 🎯 Project Overview
- **Framework**: Flutter with BLoC pattern
- **Architecture**: Clean Architecture (Core → Domain → Data → Presentation)
- **HTTP Client**: Dio with interceptors
- **State Management**: Flutter BLoC
- **Navigation**: GoRouter
- **Local Storage**: SharedPreferences

## 📂 Key Directories

```
lib/
├── core/              # Errors, DI, utilities, constants
├── config/            # App config, routes, theme
├── data/
│   ├── datasources/   # API services, HTTP client
│   ├── models/        # DTOs for API
│   └── repositories/  # Concrete implementations
├── domain/
│   ├── entities/      # Business objects
│   ├── repositories/  # Abstract interfaces
│   └── usecases/      # Business logic
└── presentation/
    ├── bloc/          # State management
    ├── pages/         # Full screens
    └── widgets/       # Reusable components
```

## 🔧 Quick Implementation Checklist

For each new feature (Classes, Teachers, etc.):

- [ ] **Models** already created in `lib/data/models/{feature}/`
- [ ] **API Service** already created in `lib/data/datasources/remote/api_services/`
- [ ] **Entity** exists in `lib/domain/entities/all_entities.dart`
- [ ] **Abstract Repository** exists in `lib/domain/repositories/all_repositories.dart`

Still need to create:
- [ ] **Repository Implementation** → `lib/data/repositories/{feature}_repository_impl.dart`
- [ ] **UseCase** → `lib/domain/usecases/{feature}_usecases.dart`
- [ ] **BLoC** → `lib/presentation/bloc/{feature}/{feature}_bloc.dart`
- [ ] **BLoC Event** → `lib/presentation/bloc/{feature}/{feature}_event.dart`
- [ ] **BLoC State** → `lib/presentation/bloc/{feature}/{feature}_state.dart`
- [ ] **List Page** → `lib/presentation/pages/{feature}s_page.dart`
- [ ] **Detail Page** → `lib/presentation/pages/{feature}/{feature}_detail_page.dart`
- [ ] **Form Page** → `lib/presentation/pages/{feature}/add_edit_{feature}_page.dart`
- [ ] **Card Widget** → `lib/presentation/widgets/cards/{feature}_card.dart`
- [ ] **Form Widget** → `lib/presentation/widgets/forms/{feature}_form.dart`
- [ ] **DI Registration** → Update `lib/core/di/injection_container.dart`

## 📝 File Naming Convention

| Component | Pattern | Example |
|-----------|---------|---------|
| Models | `{feature}_model.dart` | `class_model.dart` |
| API Service | `{feature}_api_service.dart` | `class_api_service.dart` |
| Repository Impl | `{feature}_repository_impl.dart` | `class_repository_impl.dart` |
| UseCase | `{feature}_usecases.dart` | `class_usecases.dart` |
| BLoC | `{feature}_bloc.dart` | `class_bloc.dart` |
| Event | `{feature}_event.dart` | `class_event.dart` |
| State | `{feature}_state.dart` | `class_state.dart` |
| List Page | `{feature}s_page.dart` | `classes_page.dart` |
| Detail Page | `{feature}_detail_page.dart` | `class_detail_page.dart` |
| Form Page | `add_edit_{feature}_page.dart` | `add_edit_class_page.dart` |
| Card | `{feature}_card.dart` | `class_card.dart` |
| Form Widget | `{feature}_form.dart` | `class_form.dart` |

## 🔑 Key Classes Already Implemented

### Models (22 classes)
✅ All models created with proper JSON serialization

### Entities (11 classes)
✅ All entities in `domain/entities/all_entities.dart`

### Abstract Repositories (8 repos)
✅ All in `domain/repositories/all_repositories.dart`

### API Services (9 services)
✅ All complete with full endpoint coverage

### Auth Feature (100% complete)
✅ Repository, UseCase, BLoC, Pages, Models, Entity

## 🚀 Implementation Steps for New Feature

### Step 1: Create Repository Implementation
```dart
// lib/data/repositories/{feature}_repository_impl.dart
class ClassRepositoryImpl implements ClassRepository {
  final ClassApiService apiService;
  
  ClassRepositoryImpl(this.apiService);
  
  @override
  Future<Either<Failure, List<ClassEntity>>> getAllClasses({...}) async {
    try {
      final response = await apiService.getAllClasses(...);
      return Right(_mapToEntity(response));
    } catch (e) {
      return Left(NetworkFailure(message: 'Error'));
    }
  }
}
```

### Step 2: Create UseCase
```dart
// lib/domain/usecases/{feature}_usecases.dart
class ClassUseCases {
  final ClassRepository repository;
  
  ClassUseCases(this.repository);
  
  Future<Either<Failure, List<ClassEntity>>> getAllClasses() {
    return repository.getAllClasses();
  }
}
```

### Step 3: Create BLoC Events
```dart
abstract class ClassEvent extends Equatable {}
class GetAllClassesEvent extends ClassEvent {}
```

### Step 4: Create BLoC States
```dart
abstract class ClassState extends Equatable {}
class ClassLoading extends ClassState {}
class ClassLoaded extends ClassState {
  final List<ClassEntity> classes;
}
class ClassError extends ClassState {
  final String message;
}
```

### Step 5: Create BLoC
```dart
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

### Step 6: Register in DI
```dart
// In setupServiceLocator()
getIt.registerSingleton<ClassUseCases>(
  ClassUseCases(getIt<ClassRepository>()),
);
getIt.registerSingleton<ClassBloc>(
  ClassBloc(getIt<ClassUseCases>()),
);
```

### Step 7: Create UI Pages
```dart
// List Page: classes_page.dart
// Detail Page: class_detail_page.dart
// Form Page: add_edit_class_page.dart
```

## 💡 Common Patterns

### API Call Pattern
```dart
final response = await dioClient.get('/endpoint');
final data = response.data as Map<String, dynamic>;
final model = MyModel.fromJson(data);
```

### Error Handling Pattern
```dart
try {
  // Try operation
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message, statusCode: 0));
} on NetworkException catch (e) {
  return Left(NetworkFailure(message: e.message));
} catch (e) {
  return Left(NetworkFailure(message: 'Unexpected error'));
}
```

### BLoC Event Handler Pattern
```dart
on<GetDataEvent>((event, emit) async {
  emit(Loading());
  final result = await useCase.getData();
  result.fold(
    (failure) => emit(Error(message: failure.message)),
    (data) => emit(Loaded(data: data)),
  );
});
```

### Widget Display Pattern
```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    if (state is Loading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is Loaded) {
      return ListView(children: [
        for (var item in state.items)
          MyCard(item: item)
      ]);
    } else if (state is Error) {
      return Center(child: Text(state.message));
    }
    return SizedBox.shrink();
  },
);
```

## 📚 Documentation Files

1. **API_ENDPOINTS.md** - All 71 endpoints with curl examples
2. **FOLDER_STRUCTURE.md** - Complete directory layout
3. **DEVELOPMENT_GUIDE.md** - Step-by-step implementation
4. **COMPLETE_IMPLEMENTATION_GUIDE.md** - Architecture & patterns
5. **IMPLEMENTATION_SUMMARY.md** - Current status

## ⚙️ Running the App

```bash
# Install dependencies
flutter pub get

# Analyze code
flutter analyze

# Run the app
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 🧪 Testing the API

Use the curl commands in `API_ENDPOINTS.md`:
```bash
# Login
TOKEN=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass"}' | jq -r '.data.access_token')

# Get data
curl -X GET http://localhost:8080/api/v1/classes \
  -H "Authorization: Bearer $TOKEN"
```

## 🎓 Architecture Layers

### Data Layer
- Fetches data from API/Local storage
- Models: DTOs from API
- Repositories: Concrete implementations
- Maps data to entities

### Domain Layer
- Business logic
- Entities: Pure business objects
- Repositories: Abstract contracts
- UseCases: Operations wrapper

### Presentation Layer
- UI Components
- BLoC: State management
- Pages: Full screen widgets
- Widgets: Reusable components

## 🔐 Error Handling

All errors follow this pattern:
1. Exception thrown → Exception caught in Repository
2. Exception → Failure object created
3. Failure → returned via Either (Left)
4. BLoC catches Failure → emits Error state
5. UI displays error message

## 💾 Data Flow

```
User Action (Event)
  ↓
BLoC (State manager)
  ↓
UseCase (Business logic)
  ↓
Repository (Data abstraction)
  ↓
API Service / Local Storage
  ↓
Response → Map to Entity
  ↓
Return to BLoC
  ↓
BLoC emits State
  ↓
UI rebuilds
```

## 📌 Important Notes

- ✅ All models already created
- ✅ All API services ready
- ✅ All abstract repositories ready
- ✅ Auth feature 100% complete
- ⏳ Remaining 8 features follow same pattern
- 📖 Complete guides available
- 🔗 All endpoints documented

## 🚦 Status

| Component | Status |
|-----------|--------|
| Infrastructure | ✅ 100% |
| Models | ✅ 100% |
| API Services | ✅ 100% |
| Domain Entities | ✅ 100% |
| Abstract Repos | ✅ 100% |
| Auth Feature | ✅ 100% |
| Remaining Features | ⏳ Ready to implement |
| Documentation | ✅ Complete |

---

**Ready to implement all features!** 🚀
