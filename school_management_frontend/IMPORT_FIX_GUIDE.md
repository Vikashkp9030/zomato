# Import Fix Guide - Quick Reference

This guide helps fix imports for the remaining files that need updating.

## Common Import Replacements

### Error/Failures Imports
```dart
// OLD (any location in old data/)
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';

// NEW (from feature data layer)
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
```

### Local Storage Import
```dart
// OLD
import '../datasources/local/local_storage.dart';

// NEW
import '../../../../core/services/local_storage.dart';
```

### DioClient Import
```dart
// OLD
import '../datasources/remote/dio_client.dart';

// NEW
import '../../../../core/network/dio_client.dart';
```

### Entity Imports (within same feature)
```dart
// OLD (from model file in features/students/data/models/)
import '../../../domain/entities/all_entities.dart';

// NEW
import '../../domain/entities/student_entity.dart';
```

### Repository Interface Import (in repository implementation)
```dart
// OLD (from features/students/data/repositories/)
import '../../domain/repositories/all_repositories.dart';

// NEW
import '../../domain/repositories/student_repository.dart';
```

### UseCase Import (in BLoC)
```dart
// OLD (from features/students/presentation/bloc/)
import '../../../domain/usecases/student_usecases.dart';

// NEW
import '../../domain/usecases/student_usecases.dart';
```

### Cross-Feature Imports (Authentication to Dashboard)
```dart
// In features/dashboard/presentation/pages/
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
```

---

## File-by-File Fix Template

### API Service Files
**Location**: `features/{feature}/data/datasources/{feature}_api_service.dart`

```dart
// At the top:
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/dio_client.dart';  // FIX THIS
import '../../../../core/error/exceptions.dart';     // FIX THIS
import '../models/{feature}_model.dart';
```

### Model Files
**Location**: `features/{feature}/data/models/{feature}_model.dart`

```dart
// At the top:
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/{feature}_entity.dart';  // UPDATE PATH
```

### Repository Implementation Files
**Location**: `features/{feature}/data/repositories/{feature}_repository_impl.dart`

```dart
// At the top:
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/failures.dart';           // FIX
import '../../../../core/error/exceptions.dart';        // FIX
import '../../domain/entities/{feature}_entity.dart';   // UPDATE
import '../../domain/repositories/{feature}_repository.dart'; // UPDATE
import '../datasources/{feature}_api_service.dart';
import '../models/{feature}_model.dart';
```

### UseCase Files
**Location**: `features/{feature}/domain/usecases/{feature}_usecases.dart`

```dart
// At the top:
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';                    // FIX
import '../entities/{feature}_entity.dart';
import '../repositories/{feature}_repository.dart';
```

### BLoC Event Files
**Location**: `features/{feature}/presentation/bloc/{feature}_event.dart`

```dart
// At the top:
import 'package:equatable/equatable.dart';
```

### BLoC State Files
**Location**: `features/{feature}/presentation/bloc/{feature}_state.dart`

```dart
// At the top:
import 'package:equatable/equatable.dart';
import '../../domain/entities/{feature}_entity.dart';
```

### BLoC Implementation Files
**Location**: `features/{feature}/presentation/bloc/{feature}_bloc.dart`

```dart
// At the top:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/{feature}_usecases.dart';
import '{feature}_event.dart';
import '{feature}_state.dart';
```

### Page Files
**Location**: `features/{feature}/presentation/pages/{feature}_page.dart`

```dart
// At the top:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/{feature}_bloc.dart';
import '../bloc/{feature}_event.dart';
import '../bloc/{feature}_state.dart';
```

---

## Batch Fix Commands (For Future Automation)

### Find files needing import updates
```bash
# Find all dart files with old import patterns
grep -r "import.*core/errors/" lib/features --include="*.dart"
grep -r "import.*core/observers/" lib/features --include="*.dart"
grep -r "import.*domain/entities/all_entities" lib/features --include="*.dart"
```

### Quick View of Errors
```bash
# Check what imports are causing errors
grep -r "import.*core/errors/" lib/features | head -20
```

---

## Feature-Specific Import Paths

Replace `{feature}` with actual feature name in lowercase:

### Students Feature
```
import 'features/students/domain/entities/student_entity.dart';
import 'features/students/domain/repositories/student_repository.dart';
import 'features/students/domain/usecases/student_usecases.dart';
import 'features/students/data/repositories/student_repository_impl.dart';
import 'features/students/data/datasources/student_api_service.dart';
import 'features/students/data/models/student_model.dart';
import 'features/students/presentation/bloc/student_bloc.dart';
```

### Teachers Feature
```
import 'features/teachers/domain/entities/teacher_entity.dart';
import 'features/teachers/domain/repositories/teacher_repository.dart';
import 'features/teachers/domain/usecases/teacher_usecases.dart';
import 'features/teachers/data/repositories/teacher_repository_impl.dart';
import 'features/teachers/data/datasources/teacher_api_service.dart';
import 'features/teachers/data/models/teacher_model.dart';
import 'features/teachers/presentation/bloc/teacher_bloc.dart';
```

(Pattern applies to all other features similarly)

---

## Testing Imports

After fixing imports, you can verify with:
```bash
# Check for remaining old-style imports
grep -r "import.*core/errors" lib/
grep -r "import.*core/observers" lib/
grep -r "domain/entities/all_entities" lib/
grep -r "domain/repositories/all_repositories" lib/

# Should return 0 results if all are fixed
```

---

## Priority Order for Fixing

1. **High Priority** (Blocking app)
   - `features/*/data/repositories/*_repository_impl.dart`
   - `features/*/data/datasources/*_api_service.dart`
   - `features/*/presentation/bloc/*_bloc.dart`

2. **Medium Priority** (Many files)
   - `features/*/data/models/*.dart`
   - `features/*/domain/usecases/*.dart`
   - `features/*/presentation/pages/*.dart`

3. **Low Priority** (Supporting)
   - `features/*/presentation/bloc/*_event.dart`
   - `features/*/presentation/bloc/*_state.dart`
   - `features/*/presentation/widgets/*.dart`

---

## Verification Checklist

After completing import fixes:

- [ ] No `core/errors/` imports remain
- [ ] No `core/observers/` imports remain  
- [ ] No `domain/entities/all_entities.dart` imports remain
- [ ] No `domain/repositories/all_repositories.dart` imports remain
- [ ] All `core/` imports use new paths (`core/error/`, `core/network/`, `core/services/`, etc.)
- [ ] All feature imports use feature-specific entity files
- [ ] All feature imports use feature-specific repository files
- [ ] Cross-feature imports are minimal and intentional

---

**Last Updated**: June 17, 2026  
**Purpose**: Help complete Phase 5 import fixes
