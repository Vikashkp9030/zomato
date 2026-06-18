# Flutter School Management App - Complete Setup Guide

## 📋 Prerequisites

- **Flutter SDK**: Version 3.0.0 or higher
- **Dart**: Version 3.0.0 or higher
- **IDE**: VS Code, Android Studio, or Xcode
- **Git**: For version control
- **Backend API**: Running on http://localhost:8080/api/v1

## 🚀 Project Setup

### 1. Initialize Flutter Project

```bash
# Navigate to the parent directory
cd /Users/vikashkumarpatel/GoCourse

# Create new Flutter project with clean architecture setup
flutter create --org com.school.management school_management_frontend

cd school_management_frontend
```

### 2. Configure Pubspec.yaml

Replace the content of `pubspec.yaml` with the provided configuration that includes all dependencies.

### 3. Install Dependencies

```bash
# Get all packages
flutter pub get

# Upgrade packages
flutter pub upgrade

# Analyze code
flutter analyze
```

### 4. Environment Configuration

Create `.env` file from `.env.example`:

```bash
cp .env.example .env
```

Edit `.env`:
```
BASE_URL=http://localhost:8080/api/v1
JWT_SECRET=your_jwt_secret
LOG_LEVEL=debug
```

## 📁 Folder Structure Setup

Create all required directories:

```bash
# Core directories
mkdir -p lib/config/routes lib/config/theme
mkdir -p lib/core/constants lib/core/di lib/core/errors lib/core/observers lib/core/utils
mkdir -p lib/data/datasources/remote/api_services lib/data/datasources/remote/interceptors
mkdir -p lib/data/datasources/local lib/data/models lib/data/repositories
mkdir -p lib/domain/entities lib/domain/repositories lib/domain/usecases
mkdir -p lib/presentation/bloc lib/presentation/pages lib/presentation/widgets
mkdir -p assets/images assets/icons assets/animations assets/fonts

# Test directories
mkdir -p test/domain test/data test/presentation
```

## 🔧 Generate Code

### JSON Serialization

Generate model classes:

```bash
# Generate all models
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on file changes)
flutter pub run build_runner watch
```

This will generate `*.g.dart` files for JSON serialization.

## 📦 Project Structure Details

### Core Layer (lib/core/)

**constants/app_constants.dart** - API endpoints and app constants
**di/injection_container.dart** - Service locator setup
**errors/exceptions.dart** - Custom exceptions
**errors/failures.dart** - Failure definitions
**observers/bloc_observer.dart** - BLoC event logging
**utils/validators.dart** - Input validation

### Data Layer (lib/data/)

**datasources/remote/dio_client.dart** - HTTP client wrapper
**datasources/local/local_storage.dart** - Shared preferences wrapper
**models/** - Data models with JSON serialization
**repositories/** - Repository implementations

### Domain Layer (lib/domain/)

**entities/** - Business logic entities
**repositories/** - Abstract repository interfaces
**usecases/** - Use cases for each feature

### Presentation Layer (lib/presentation/)

**bloc/** - BLoCs for state management
**pages/** - Screen/page widgets
**widgets/** - Reusable UI components

## 🎨 Theme Setup

The app includes complete Material 3 theming:

- **Colors**: Primary (Blue), Secondary (Green), Accent (Amber), Error (Red)
- **Typography**: Google Fonts (Poppins)
- **Components**: Buttons, Input fields, Cards with consistent styling
- **Spacing**: Standard padding/margin values
- **Border Radius**: Consistent corner radius

Light and Dark themes are pre-configured in `config/theme/app_theme.dart`.

## 🔐 Authentication Flow

1. **Login Page** → User enters credentials
2. **Auth BLoC** → Validates and authenticates
3. **Token Storage** → Saves JWT tokens locally
4. **Dashboard** → Navigates on success
5. **Token Interceptor** → Attaches token to requests
6. **Auto Refresh** → Automatically refreshes expired tokens

Login Credentials (Dummy Data):
```
Email: vikash798561@gmail.com
Password: Vikash@123
```

## 🎯 BLoC Pattern

Each feature implements BLoC with three files:

**example_bloc.dart**
```dart
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final ExampleUseCases useCases;
  
  ExampleBloc(this.useCases) : super(ExampleInitial()) {
    on<GetExamplesEvent>(_onGetExamples);
  }
  
  Future<void> _onGetExamples(
    GetExamplesEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(ExampleLoading());
    final result = await useCases.getExamples();
    result.fold(
      (failure) => emit(ExampleError(failure.message)),
      (examples) => emit(ExamplesLoaded(examples)),
    );
  }
}
```

**example_event.dart**
```dart
abstract class ExampleEvent extends Equatable {
  const ExampleEvent();
}

class GetExamplesEvent extends ExampleEvent {
  @override
  List<Object?> get props => [];
}
```

**example_state.dart**
```dart
abstract class ExampleState extends Equatable {
  const ExampleState();
}

class ExampleInitial extends ExampleState {
  @override
  List<Object?> get props => [];
}

class ExampleLoading extends ExampleState {
  @override
  List<Object?> get props => [];
}

class ExamplesLoaded extends ExampleState {
  final List<ExampleEntity> examples;
  const ExamplesLoaded(this.examples);
  
  @override
  List<Object?> get props => [examples];
}

class ExampleError extends ExampleState {
  final String message;
  const ExampleError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

## 🌐 API Integration

### 1. Create API Service

**lib/data/datasources/remote/api_services/example_api_service.dart**
```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../models/example/example_model.dart';

part 'example_api_service.g.dart';

@RestApi()
abstract class ExampleApiService {
  factory ExampleApiService(Dio dio, {String baseUrl}) = _ExampleApiService;

  @GET('/examples')
  Future<HttpResponse<List<ExampleModel>>> getExamples(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/examples/{id}')
  Future<HttpResponse<ExampleModel>> getExampleById(@Path('id') int id);

  @POST('/examples')
  Future<HttpResponse<ExampleModel>> createExample(
    @Body() ExampleModel example,
  );

  @PUT('/examples/{id}')
  Future<HttpResponse<ExampleModel>> updateExample(
    @Path('id') int id,
    @Body() ExampleModel example,
  );

  @DELETE('/examples/{id}')
  Future<HttpResponse<void>> deleteExample(@Path('id') int id);
}
```

### 2. Create Repository Implementation

**lib/data/repositories/example_repository_impl.dart**
```dart
import '../../domain/repositories/example_repository.dart';
import '../datasources/remote/dio_client.dart';
import '../models/example/example_model.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final DioClient dioClient;

  ExampleRepositoryImpl(this.dioClient);

  @override
  Future<Either<Failure, List<ExampleEntity>>> getExamples() async {
    try {
      final response = await dioClient.getExamples(page: 1, limit: 10);
      return Right(response.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### 3. Create UseCase

**lib/domain/usecases/example_usecase.dart**
```dart
class ExampleUseCases {
  final ExampleRepository repository;

  ExampleUseCases(this.repository);

  Future<Either<Failure, List<ExampleEntity>>> getExamples() {
    return repository.getExamples();
  }
}
```

## 🛠️ Development Workflow

### 1. Start Backend

```bash
cd /Users/vikashkumarpatel/GoCourse/school_management
make run
```

### 2. Run Flutter App

```bash
cd /Users/vikashkumarpatel/GoCourse/school_management_frontend

# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

### 3. Hot Reload

Press `r` in terminal to hot reload during development.

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/domain/usecases_test.dart

# Run with coverage
flutter test --coverage
```

Example test:

```dart
void main() {
  group('ExampleBloc', () {
    late ExampleBloc exampleBloc;
    late MockExampleUseCases mockUseCases;

    setUp(() {
      mockUseCases = MockExampleUseCases();
      exampleBloc = ExampleBloc(mockUseCases);
    });

    tearDown(() {
      exampleBloc.close();
    });

    test('emit [ExampleLoading, ExamplesLoaded] when getExamples is successful',
        () async {
      final examples = [ExampleEntity(id: 1, name: 'Example')];
      
      when(mockUseCases.getExamples())
          .thenAnswer((_) async => Right(examples));

      expect(
        exampleBloc.stream,
        emitsInOrder([
          ExampleLoading(),
          ExamplesLoaded(examples),
        ]),
      );

      exampleBloc.add(GetExamplesEvent());
    });
  });
}
```

## 🚢 Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS

```bash
# Build iOS
flutter build ios --release
```

## 📱 Screen Sizes & Responsive Design

The app is optimized for:
- **Mobile**: 360px - 480px (Small phones)
- **Tablet**: 600px - 1200px
- **Desktop**: 1200px+

Use `MediaQuery` for responsive layouts:

```dart
final screenWidth = MediaQuery.of(context).size.width;
final isMobile = screenWidth < 600;
```

## 🔍 Debugging

### Enable DevTools

```bash
flutter pub global activate devtools
devtools
```

### Debug Mode

```bash
flutter run -v  # Verbose logging
```

### BLoC Observer Logs

The app logs all BLoC events, transitions, and errors to console.

## 📊 Navigation Structure

```
Splash
  ↓
Login → Register
  ↓
Dashboard
  ├── Classes
  │   ├── Class List
  │   ├── Class Detail
  │   └── Add/Edit Class
  ├── Teachers
  │   ├── Teacher List
  │   ├── Teacher Detail
  │   └── Add/Edit Teacher
  ├── Subjects
  ├── Students
  ├── Exams
  ├── Results
  ├── Attendance
  ├── Parents
  └── Profile
```

## 🐛 Common Issues & Solutions

### Issue: Packages not found
```bash
flutter pub get
flutter pub upgrade
```

### Issue: Build runner fails
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Cache issues
```bash
flutter clean
flutter pub get
```

### Issue: Port already in use
Change API port in `.env`:
```
BASE_URL=http://localhost:9090/api/v1
```

## 📚 Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev/)
- [GoRouter](https://pub.dev/packages/go_router)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Material Design 3](https://m3.material.io/)

## 🎓 Code Examples

### Pagination Example

```dart
class ClassBloc extends Bloc<ClassEvent, ClassState> {
  int currentPage = 1;
  final List<ClassEntity> allClasses = [];

  ClassBloc(this.useCases) : super(ClassInitial()) {
    on<GetClassesEvent>(_onGetClasses);
    on<LoadMoreClassesEvent>(_onLoadMoreClasses);
  }

  Future<void> _onGetClasses(
    GetClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    currentPage = 1;
    allClasses.clear();
    
    final result = await useCases.getClasses(page: currentPage);
    result.fold(
      (failure) => emit(ClassError(failure.message)),
      (classes) {
        allClasses.addAll(classes);
        emit(ClassLoaded(classes, hasMoreData: classes.length == 10));
      },
    );
  }

  Future<void> _onLoadMoreClasses(
    LoadMoreClassesEvent event,
    Emitter<ClassState> emit,
  ) async {
    final currentState = state;
    if (currentState is ClassLoaded) {
      currentPage++;
      
      final result = await useCases.getClasses(page: currentPage);
      result.fold(
        (failure) => emit(ClassError(failure.message)),
        (classes) {
          allClasses.addAll(classes);
          emit(ClassLoaded(
            allClasses,
            hasMoreData: classes.length == 10,
          ));
        },
      );
    }
  }
}
```

## ✅ Pre-Launch Checklist

- [ ] Update API base URL in `.env`
- [ ] Test login with dummy credentials
- [ ] Test all CRUD operations
- [ ] Test navigation between screens
- [ ] Test error handling
- [ ] Test offline functionality (if implemented)
- [ ] Run tests: `flutter test`
- [ ] Fix analysis issues: `flutter analyze`
- [ ] Build release APK/IPA
- [ ] Test on real device
- [ ] Check performance

## 📞 Support

For issues or questions:
1. Check the Flutter documentation
2. Review BLoC pattern documentation
3. Check API logs for backend errors
4. Enable verbose logging: `flutter run -v`

---

**Last Updated**: June 16, 2026  
**Version**: 1.0.0  
**Status**: Ready for Development ✅
