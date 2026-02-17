# Step 3: Data Layer - Projects Feature ✅

## What We Built:

### 1. **Project Model** (`data/models/project_model.dart`)

**Purpose**: Data transfer object with JSON serialization

```dart
class ProjectModel extends ProjectEntity {
  Map<String, dynamic> toJson() => {...};
  factory ProjectModel.fromJson(Map<String, dynamic> json) => ...;
  factory ProjectModel.fromEntity(ProjectEntity entity) => ...;
}
```

**Key Points:**
- ✅ Extends ProjectEntity (inherits business logic)
- ✅ Has JSON serialization (toJson/fromJson)
- ✅ Can convert Entity → Model
- ✅ Used for data transfer only

**Why extend Entity?**
- Model IS-A Entity (can be used anywhere Entity is expected)
- Inherits all business logic
- No code duplication

---

### 2. **Local Data Source** (`data/datasources/project_local_datasource.dart`)

**Purpose**: Cache projects locally using SharedPreferences

```dart
abstract class ProjectLocalDataSource {
  Future<List<ProjectModel>> getCachedProjects();
  Future<void> cacheProjects(List<ProjectModel> projects);
}
```

**Implementation:**
- Uses SharedPreferences
- Stores projects as JSON string
- Throws CacheException on errors

**Why separate interface?**
- Easy to test (mock data source)
- Can swap implementations (Hive, SQLite, etc.)
- Single Responsibility

---

### 3. **Remote Data Source** (`data/datasources/project_remote_datasource.dart`)

**Purpose**: Fetch projects from remote source

```dart
abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
}
```

**Current Implementation:**
- Returns sample data
- Simulates network delay
- Throws ServerException on errors

**Future Enhancement:**
- Replace with actual API calls
- Add authentication
- Handle pagination

---

### 4. **Repository Implementation** (`data/repositories/project_repository_impl.dart`)

**Purpose**: Glue between data sources and domain layer

```dart
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;
  
  // Implements all methods from ProjectRepository interface
}
```

**Key Responsibilities:**
1. **Fetch data** from remote/local sources
2. **Convert** Model → Entity
3. **Handle errors** (Exception → Failure)
4. **Cache strategy** (remote first, fallback to cache)

**Error Handling Flow:**
```
Try Remote
  ↓ Success → Cache → Return
  ↓ Failure
Try Cache
  ↓ Success → Return
  ↓ Failure → Return Failure
```

---

## 🎯 Data Flow Example:

### **Getting Projects:**

```
1. UI calls UseCase
   ↓
2. UseCase calls Repository.getProjects()
   ↓
3. Repository tries RemoteDataSource
   ↓
4. RemoteDataSource returns List<ProjectModel>
   ↓
5. Repository caches to LocalDataSource
   ↓
6. Repository returns Right(List<ProjectEntity>)
   ↓
7. UseCase returns to UI
   ↓
8. UI displays projects
```

### **If Remote Fails:**

```
3. RemoteDataSource throws ServerException
   ↓
4. Repository catches exception
   ↓
5. Repository tries LocalDataSource
   ↓
6. LocalDataSource returns cached List<ProjectModel>
   ↓
7. Repository returns Right(List<ProjectEntity>)
```

---

## 📊 Current Structure:

```
lib/
├── core/                          ✅
│   ├── error/
│   └── usecases/
│
└── features/
    └── projects/
        ├── domain/                ✅
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        │
        └── data/                  ✅ COMPLETE
            ├── models/
            │   └── project_model.dart
            ├── datasources/
            │   ├── project_local_datasource.dart
            │   └── project_remote_datasource.dart
            └── repositories/
                └── project_repository_impl.dart
```

---

## 🎓 Key Concepts:

### **1. Model extends Entity**

```dart
// Entity (Domain)
class ProjectEntity {
  final String title;
}

// Model (Data) - extends Entity
class ProjectModel extends ProjectEntity {
  ProjectModel({required super.title});
  
  // JSON methods
  Map<String, dynamic> toJson() => {'title': title};
  factory ProjectModel.fromJson(json) => ProjectModel(title: json['title']);
}
```

**Benefits:**
- Model IS-A Entity
- Can return Model where Entity is expected
- No manual conversion needed

### **2. Data Source Pattern**

**Why separate data sources?**
- Single Responsibility
- Easy to test
- Can swap implementations
- Clear separation of concerns

**Example:**
```dart
// Can easily swap:
ProjectLocalDataSourceImpl(sharedPreferences)
// With:
ProjectLocalDataSourceHive(hiveBox)
```

### **3. Repository as Mediator**

Repository decides:
- Which data source to use
- When to cache
- How to handle errors
- Model → Entity conversion

**Example:**
```dart
// Repository logic:
try {
  final models = await remoteDataSource.getProjects();
  await localDataSource.cacheProjects(models);
  return Right(models); // Models are Entities
} catch (e) {
  final cached = await localDataSource.getCachedProjects();
  return Right(cached);
}
```

---

## 🔄 Exception → Failure Conversion:

```dart
// Data Source throws Exception
throw ServerException('API error');

// Repository catches and converts to Failure
catch (ServerException e) {
  return Left(ServerFailure(e.message));
}

// UseCase returns Either<Failure, Data>
// UI handles Failure gracefully
```

---

## ✅ What's Next: Step 4

We'll create the **Presentation Layer**:
1. **State Classes** (Loading, Success, Error)
2. **Provider with States** (Advanced state management)
3. **Update UI** to use new architecture

This will complete the Projects feature!

---

## 🎓 Understanding Check:

1. ✅ Why does ProjectModel extend ProjectEntity?
2. ✅ What's the difference between data source and repository?
3. ✅ How does repository handle errors?
4. ✅ What's the cache strategy?

**Answers:**
1. To inherit business logic and be usable as Entity
2. Data source fetches data, repository orchestrates and converts
3. Catches exceptions, converts to Failures, returns Either
4. Try remote first, cache result, fallback to cache on failure

**Ready for Step 4?** Type "continue"! 🚀
