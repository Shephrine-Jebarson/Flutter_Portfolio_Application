# Step 2: Domain Layer - Projects Feature ✅

## What We Built:

### 1. **Project Entity** (`domain/entities/project_entity.dart`)

**Purpose**: Pure business object representing a project

```dart
class ProjectEntity extends Equatable {
  final int id;
  final String title;
  final String category;
  // ... other fields
}
```

**Key Points:**
- ✅ No JSON serialization (toJson/fromJson)
- ✅ No framework dependencies
- ✅ Uses Equatable for value comparison
- ✅ Contains business logic (isCompleted getter)
- ✅ Immutable (all fields final)

**Why Entity vs Model?**
- **Entity** = Business object (domain layer)
- **Model** = Data transfer object (data layer, has JSON)

---

### 2. **Repository Interface** (`domain/repositories/project_repository.dart`)

**Purpose**: Contract defining what data operations are available

```dart
abstract class ProjectRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, void>> addProject(ProjectEntity project);
  Future<Either<Failure, void>> updateProject(ProjectEntity project);
  Future<Either<Failure, ProjectEntity>> getProjectById(int id);
}
```

**Key Points:**
- ✅ Abstract class (interface)
- ✅ Returns Either<Failure, Data>
- ✅ Implementation will be in data layer
- ✅ Domain layer doesn't know HOW data is fetched

**Why Interface?**
- Dependency Inversion Principle
- Domain layer defines what it needs
- Data layer implements how to get it
- Easy to swap implementations (API, Cache, Mock)

---

### 3. **Use Cases** (Business Operations)

#### **GetProjects** - Fetch all projects
```dart
class GetProjects extends UseCase<List<ProjectEntity>, NoParams> {
  final ProjectRepository repository;
  
  @override
  Future<Either<Failure, List<ProjectEntity>>> call(NoParams params) {
    return repository.getProjects();
  }
}
```

#### **AddProject** - Add new project
```dart
class AddProject extends UseCase<void, AddProjectParams> {
  // Takes AddProjectParams (contains ProjectEntity)
}
```

#### **UpdateProject** - Update existing project
```dart
class UpdateProject extends UseCase<void, UpdateProjectParams> {
  // Takes UpdateProjectParams (contains ProjectEntity)
}
```

#### **GetProjectById** - Get single project
```dart
class GetProjectById extends UseCase<ProjectEntity, GetProjectByIdParams> {
  // Takes GetProjectByIdParams (contains id)
}
```

**Key Points:**
- ✅ One responsibility per use case
- ✅ Extends base UseCase
- ✅ Takes repository as dependency
- ✅ Returns Either<Failure, Data>

---

## 🎯 Architecture Pattern:

### **Dependency Flow:**
```
UseCase → Repository Interface
    ↓
Repository Implementation (Data Layer)
    ↓
Data Source (API/Cache)
```

### **Data Flow:**
```
UI calls UseCase
    ↓
UseCase calls Repository
    ↓
Repository fetches from DataSource
    ↓
Repository converts Model → Entity
    ↓
UseCase returns Either<Failure, Entity>
    ↓
UI displays data or error
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
        └── domain/                ✅ COMPLETE
            ├── entities/
            │   └── project_entity.dart
            ├── repositories/
            │   └── project_repository.dart
            └── usecases/
                ├── get_projects.dart
                ├── add_project.dart
                ├── update_project.dart
                └── get_project_by_id.dart
```

---

## 🎓 Key Concepts:

### **1. Entity vs Model**

| Aspect | Entity | Model |
|--------|--------|-------|
| Layer | Domain | Data |
| Purpose | Business logic | Data transfer |
| JSON | No | Yes (toJson/fromJson) |
| Dependencies | None | Framework (json_annotation) |
| Example | ProjectEntity | ProjectModel |

### **2. Repository Pattern**

**Interface (Domain):**
```dart
abstract class ProjectRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
}
```

**Implementation (Data):**
```dart
class ProjectRepositoryImpl implements ProjectRepository {
  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() {
    // Actual implementation
  }
}
```

**Benefits:**
- Domain doesn't depend on data layer
- Easy to test (mock repository)
- Can swap implementations

### **3. Use Case Pattern**

**Why separate use cases?**
- Single Responsibility Principle
- Easy to test
- Reusable business logic
- Clear intent

**Example:**
```dart
// In UI:
final result = await getProjects(NoParams());
result.fold(
  (failure) => showError(failure.message),
  (projects) => displayProjects(projects),
);
```

---

## ✅ What's Next: Step 3

We'll create the **Data Layer**:
1. **Project Model** (with JSON serialization)
2. **Data Sources** (Remote API & Local Cache)
3. **Repository Implementation** (converts Model → Entity)

This will connect our domain layer to actual data!

---

## 🎓 Understanding Check:

1. ✅ What's the difference between Entity and Model?
2. ✅ Why do we need a repository interface?
3. ✅ Why separate use cases instead of one big class?
4. ✅ What does the domain layer depend on?

**Answer to #4**: NOTHING! Domain is independent.

**Ready for Step 3?** Type "continue"! 🚀
