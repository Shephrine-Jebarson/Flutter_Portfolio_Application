import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/add_project.dart';
import '../../domain/usecases/get_project_by_id.dart';
import '../../domain/usecases/get_projects.dart';
import '../../domain/usecases/update_project.dart';
import '../state/project_state.dart';

/// Provider for managing project state
class ProjectProvider extends ChangeNotifier {
  final GetProjects getProjectsUseCase;
  final AddProject addProjectUseCase;
  final UpdateProject updateProjectUseCase;
  final GetProjectById getProjectByIdUseCase;

  ProjectProvider({
    required this.getProjectsUseCase,
    required this.addProjectUseCase,
    required this.updateProjectUseCase,
    required this.getProjectByIdUseCase,
  });

  ProjectState _state = const ProjectInitial();
  ProjectState get state => _state;

  List<ProjectEntity> _projects = [];
  List<ProjectEntity> get projects => _projects;

  bool get isLoading => _state is ProjectLoading;
  bool get hasError => _state is ProjectError;
  bool get hasData => _state is ProjectLoaded;

  /// Load all projects
  Future<void> loadProjects() async {
    _state = const ProjectLoading();
    notifyListeners();

    final result = await getProjectsUseCase(const NoParams());

    result.fold(
      (failure) {
        _state = ProjectError(failure.message);
        notifyListeners();
      },
      (projects) {
        _projects = projects;
        _state = ProjectLoaded(projects);
        notifyListeners();
      },
    );
  }

  /// Add new project
  Future<void> addProject(ProjectEntity project) async {
    final result = await addProjectUseCase(AddProjectParams(project));

    result.fold(
      (failure) {
        _state = ProjectError(failure.message);
        notifyListeners();
      },
      (_) {
        _state = const ProjectOperationSuccess('Project added successfully');
        notifyListeners();
        loadProjects(); // Reload projects
      },
    );
  }

  /// Update existing project
  Future<void> updateProject(ProjectEntity project) async {
    final result = await updateProjectUseCase(UpdateProjectParams(project));

    result.fold(
      (failure) {
        _state = ProjectError(failure.message);
        notifyListeners();
      },
      (_) {
        _state = const ProjectOperationSuccess('Project updated successfully');
        notifyListeners();
        loadProjects(); // Reload projects
      },
    );
  }

  /// Get project by ID
  Future<ProjectEntity?> getProjectById(int id) async {
    final result = await getProjectByIdUseCase(GetProjectByIdParams(id));

    return result.fold(
      (failure) => null,
      (project) => project,
    );
  }

  /// Computed properties
  int get projectCount => _projects.length;

  Set<String> get uniqueLanguages {
    return _projects
        .map((p) => p.techStack.split(',').map((e) => e.trim()))
        .expand((e) => e)
        .where((lang) => lang.isNotEmpty)
        .toSet();
  }

  Set<String> get uniquePlatforms {
    return _projects.map((p) => p.platform).where((p) => p.isNotEmpty).toSet();
  }
}
