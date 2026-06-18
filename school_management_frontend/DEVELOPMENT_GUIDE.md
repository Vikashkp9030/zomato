# Development Guide - School Management App

## Quick Start

### 1. Setup
```bash
cd school_management_frontend
flutter pub get
cp .env.example .env  # Configure API base URL
flutter run
```

### 2. Project Structure Overview

**Clean Architecture Layers:**
- **Core** - Constants, errors, DI, utilities
- **Data** - Models, API services, repositories, local storage
- **Domain** - Entities, abstract repositories, use cases
- **Presentation** - BLoC, pages, widgets, routing

---

## Adding a New Feature

### Step 1: Create Models
`lib/data/models/[feature]/`
```dart
class [Feature]Model {
  factory [Feature]Model.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### Step 2: Create API Service
`lib/data/datasources/remote/api_services/[feature]_api_service.dart`
```dart
class [Feature]ApiService {
  final DioClient dioClient;
  
  Future<[Feature]Model> get[Feature]() async {
    final response = await dioClient.get('/[feature]');
    return [Feature]Model.fromJson(response.data);
  }
}
```

### Step 3: Create Domain Entity
`lib/domain/entities/[feature]_entity.dart`
```dart
class [Feature]Entity extends Equatable {
  final String id;
  // Add properties
  
  @override
  List<Object?> get props => [id]; // Add all properties
}
```

### Step 4: Create Repository Interface
`lib/domain/repositories/[feature]_repository.dart`
```dart
abstract class [Feature]Repository {
  Future<Either<Failure, [Feature]Entity>> get[Feature]();
  // Add other operations
}
```

### Step 5: Create Repository Implementation
`lib/data/repositories/[feature]_repository_impl.dart`
```dart
class [Feature]RepositoryImpl implements [Feature]Repository {
  final [Feature]ApiService apiService;
  final LocalStorage localStorage;
  
  @override
  Future<Either<Failure, [Feature]Entity>> get[Feature]() async {
    try {
      final response = await apiService.get[Feature]();
      // Map to entity
      return Right(mappedEntity);
    } catch (e) {
      return Left(NetworkFailure(message: 'Error'));
    }
  }
}
```

### Step 6: Create Use Cases
`lib/domain/usecases/[feature]_usecases.dart`
```dart
class [Feature]UseCases {
  final [Feature]Repository repository;
  
  [Feature]UseCases(this.repository);
  
  Future<Either<Failure, [Feature]Entity>> get[Feature]() {
    return repository.get[Feature]();
  }
}
```

### Step 7: Create BLoC Events & States
**Events** - `lib/presentation/bloc/[feature]/[feature]_event.dart`
```dart
abstract class [Feature]Event extends Equatable {
  const [Feature]Event();
  @override
  List<Object?> get props => [];
}

class Get[Feature]Event extends [Feature]Event {
  const Get[Feature]Event();
}
```

**States** - `lib/presentation/bloc/[feature]/[feature]_state.dart`
```dart
abstract class [Feature]State extends Equatable {
  const [Feature]State();
}

class [Feature]Loading extends [Feature]State {
  const [Feature]Loading();
}

class [Feature]Loaded extends [Feature]State {
  final [Feature]Entity [feature];
  const [Feature]Loaded({required this.[feature]});
  @override
  List<Object?> get props => [[feature]];
}

class [Feature]Error extends [Feature]State {
  final String message;
  const [Feature]Error({required this.message});
  @override
  List<Object?> get props => [message];
}
```

### Step 8: Create BLoC
`lib/presentation/bloc/[feature]/[feature]_bloc.dart`
```dart
class [Feature]Bloc extends Bloc<[Feature]Event, [Feature]State> {
  final [Feature]UseCases useCases;
  
  [Feature]Bloc(this.useCases) : super(const [Feature]Initial()) {
    on<Get[Feature]Event>(_onGet[Feature]);
  }
  
  Future<void> _onGet[Feature](
    Get[Feature]Event event,
    Emitter<[Feature]State> emit,
  ) async {
    emit(const [Feature]Loading());
    final result = await useCases.get[Feature]();
    result.fold(
      (failure) => emit([Feature]Error(message: failure.message)),
      ([feature]) => emit([Feature]Loaded([feature]: [feature])),
    );
  }
}
```

### Step 9: Register in DI Container
`lib/core/di/injection_container.dart`
```dart
// Add to setupServiceLocator():

// API Services
getIt.registerSingleton<[Feature]ApiService>(
  [Feature]ApiService(getIt<DioClient>()),
);

// Repositories
getIt.registerSingleton<[Feature]Repository>(
  [Feature]RepositoryImpl(getIt<[Feature]ApiService>()),
);

// Use Cases
getIt.registerSingleton<[Feature]UseCases>(
  [Feature]UseCases(getIt<[Feature]Repository>()),
);

// BLoCs
getIt.registerSingleton<[Feature]Bloc>(
  [Feature]Bloc(getIt<[Feature]UseCases>()),
);
```

### Step 10: Create UI Pages
`lib/presentation/pages/[feature]/`

**List Page Example:**
```dart
class [Feature]sPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('[Features]')),
      body: BlocBuilder<[Feature]Bloc, [Feature]State>(
        builder: (context, state) {
          if (state is [Feature]Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is [Feature]Loaded) {
            return ListView.builder(
              itemCount: state.[features].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.[features][index].name),
                );
              },
            );
          } else if (state is [Feature]Error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### Step 11: Add Routes
`lib/config/routes/router.dart`
```dart
GoRoute(
  path: '/[features]',
  builder: (context, state) => const [Features]Page(),
),
```

### Step 12: Add to Navigation
Update dashboard or relevant page to include navigation to new feature.

---

## Error Handling Pattern

Always use Either pattern for error handling:

```dart
// In repositories
Future<Either<Failure, SomeEntity>> getSomething() async {
  try {
    final response = await apiService.getSomething();
    return Right(mappedEntity);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  } catch (e) {
    return Left(NetworkFailure(message: 'An error occurred'));
  }
}
```

---

## Testing

### Unit Tests
```dart
test('should return entity when API call succeeds', () async {
  when(mockApiService.getSomething()).thenAnswer(
    (_) async => somethingModel,
  );
  
  final result = await repository.getSomething();
  
  expect(result, Right(somethingEntity));
});
```

### Widget Tests
```dart
testWidgets('should show list when loaded', (tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.byType(ListView), findsOneWidget);
});
```

### BLoC Tests
```dart
blocTest<[Feature]Bloc, [Feature]State>(
  'emits [Loading, Loaded] when Get[Feature] is added',
  build: () => bloc,
  act: (bloc) => bloc.add(const Get[Feature]Event()),
  expect: () => [
    const [Feature]Loading(),
    [Feature]Loaded([feature]: somethingEntity),
  ],
);
```

---

## Best Practices

### 1. State Management
- Always emit loading state first
- Use proper error states
- Keep states immutable

### 2. Error Handling
- Use custom exceptions for different error types
- Convert exceptions to failures in repositories
- Show user-friendly error messages in UI

### 3. API Integration
- Use the DioClient for all HTTP requests
- Handle network timeouts properly
- Log requests and responses

### 4. Code Organization
- Keep files under 300 lines
- One class per file
- Use meaningful names

### 5. Null Safety
- Use non-null assertions carefully
- Prefer optional types when appropriate
- Validate API responses

---

## Common Tasks

### Add Authentication Token to Requests
The token is automatically added via interceptor in `DioClient`.

### Store Data Locally
```dart
// Save
await localStorage.saveString('key', 'value');

// Retrieve
final value = localStorage.getString('key');

// Clear
await localStorage.clear();
```

### Navigate with Parameters
```dart
context.push('/details/$id');

// In router:
GoRoute(
  path: '/details/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    return DetailsPage(id: id);
  },
),
```

### Show Messages to User
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(message)),
);
```

---

## Debugging

### Enable Logging
```dart
// Already enabled in bloc_observer.dart
// Check logs in console
```

### BLoC DevTools
```bash
flutter pub add flutter_bloc
# Use BlocObserver to track all state changes
```

### Network Debugging
All Dio requests/responses are logged via `AuthInterceptor` and `ErrorInterceptor`.

---

## Performance Tips

1. Use `const` constructors everywhere possible
2. Implement `shouldRebuild` in widgets
3. Lazy load data with pagination
4. Cache API responses in local storage
5. Use `SingleChildScrollView` only when necessary

---

## Folder Structure Template

For each new feature, follow this structure:

```
lib/
├── data/
│   ├── datasources/remote/api_services/
│   │   └── [feature]_api_service.dart
│   ├── models/[feature]/
│   │   ├── [feature]_model.dart
│   │   └── [feature]_request.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [feature]_entity.dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   └── usecases/
│       └── [feature]_usecases.dart
└── presentation/
    ├── bloc/[feature]/
    │   ├── [feature]_bloc.dart
    │   ├── [feature]_event.dart
    │   └── [feature]_state.dart
    └── pages/[feature]/
        ├── [feature]s_page.dart
        ├── [feature]_detail_page.dart
        └── add_edit_[feature]_page.dart
```

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev)
- [Clean Architecture](https://resocoder.com/clean-architecture-flutter)
- [GoRouter](https://pub.dev/packages/go_router)

---

**Happy Coding!** 🚀
