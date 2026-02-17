# Step 1: Core Setup - COMPLETE ✅

## What We Built:

### 1. **Failure Classes** (`core/error/failures.dart`)

**Purpose**: Standardized error handling across the app

```dart
abstract class Failure {
  final String message;
}
```

**Types of Failures:**
- `ServerFailure` - API errors (404, 500, etc.)
- `CacheFailure` - Local storage errors
- `NetworkFailure` - No internet, timeout
- `ValidationFailure` - Invalid user input

**Why?** 
- Consistent error handling
- Easy to display user-friendly messages
- Type-safe error checking

---

### 2. **Exception Classes** (`core/error/exceptions.dart`)

**Purpose**: Data layer exceptions (thrown by data sources)

**Difference from Failures:**
- **Exceptions** = Thrown in data layer (technical errors)
- **Failures** = Returned in domain layer (business errors)

**Flow:**
```
DataSource throws ServerException
    ↓
Repository catches it
    ↓
Repository returns ServerFailure
    ↓
UseCase returns Either<Failure, Data>
```

---

### 3. **Base UseCase** (`core/usecases/usecase.dart`)

**Purpose**: Template for all business operations

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
```

**Explanation:**
- `Type` = What the use case returns (e.g., List<Project>)
- `Params` = What the use case needs (e.g., ProjectId)
- `Either<Failure, Type>` = Returns EITHER an error OR success

**Example:**
```dart
// Get all projects
class GetProjects extends UseCase<List<Project>, NoParams> {
  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) {
    // Business logic here
  }
}
```

---

### 4. **Added Packages**

**dartz** - Functional programming
- Provides `Either<Left, Right>` type
- Left = Failure, Right = Success
- No need for try-catch everywhere

**equatable** - Value equality
- Compare objects by value, not reference
- Useful for state management
- Reduces boilerplate

---

## 🎯 Key Concepts:

### **Either Type (Functional Error Handling)**

Instead of:
```dart
try {
  var data = await api.getData();
  return data;
} catch (e) {
  throw Exception(e);
}
```

We use:
```dart
Future<Either<Failure, Data>> getData() async {
  try {
    var data = await api.getData();
    return Right(data); // Success
  } catch (e) {
    return Left(ServerFailure('Error')); // Failure
  }
}
```

**Benefits:**
- No exceptions thrown
- Explicit error handling
- Type-safe
- Easier to test

---

### **Failure vs Exception**

| Aspect | Exception | Failure |
|--------|-----------|---------|
| Layer | Data | Domain |
| Type | Technical error | Business error |
| Handling | try-catch | Either<Failure, T> |
| Example | ServerException | ServerFailure |

---

## 📁 Current Structure:

```
lib/
├── core/
│   ├── error/
│   │   ├── failures.dart      ✅ (Domain layer errors)
│   │   └── exceptions.dart    ✅ (Data layer errors)
│   └── usecases/
│       └── usecase.dart       ✅ (Base use case template)
└── features/                  (Next step)
```

---

## ✅ What's Next: Step 2

We'll create the **Projects Feature** with:
1. **Domain Layer**
   - Project entity (business object)
   - Repository interface (contract)
   - Use cases (GetProjects, AddProject, UpdateProject)

This will show you how to use the core classes we just created!

---

## 🎓 Understanding Check:

Before moving forward, make sure you understand:
1. ✅ What is a Failure vs Exception?
2. ✅ What is Either<Left, Right>?
3. ✅ Why do we need a base UseCase?
4. ✅ What's the purpose of the core layer?

**Ready for Step 2?** Type "continue" when ready! 🚀
