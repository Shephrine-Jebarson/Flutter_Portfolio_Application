import 'package:shared_preferences/shared_preferences.dart';
import 'features/projects/data/datasources/project_local_datasource.dart';
import 'features/projects/data/datasources/project_remote_datasource.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/add_project.dart';
import 'features/projects/domain/usecases/get_project_by_id.dart';
import 'features/projects/domain/usecases/get_projects.dart';
import 'features/projects/domain/usecases/update_project.dart';
import 'features/projects/presentation/providers/project_provider.dart';

/// Dependency Injection Container
class InjectionContainer {
  static late SharedPreferences _sharedPreferences;

  /// Initialize dependencies
  static Future<void> init() async {
    // External dependencies
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Get ProjectProvider with all dependencies
  static ProjectProvider getProjectProvider() {
    // Data sources
    final localDataSource = ProjectLocalDataSourceImpl(_sharedPreferences);
    final remoteDataSource = ProjectRemoteDataSourceImpl();

    // Repository
    final repository = ProjectRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // Use cases
    final getProjects = GetProjects(repository);
    final addProject = AddProject(repository);
    final updateProject = UpdateProject(repository);
    final getProjectById = GetProjectById(repository);

    // Provider
    return ProjectProvider(
      getProjectsUseCase: getProjects,
      addProjectUseCase: addProject,
      updateProjectUseCase: updateProject,
      getProjectByIdUseCase: getProjectById,
    );
  }
}
