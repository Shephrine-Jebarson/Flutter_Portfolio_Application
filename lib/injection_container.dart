import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/projects/data/datasources/project_local_datasource.dart';
import 'features/projects/data/datasources/project_remote_datasource.dart';
import 'features/projects/data/models/project_local_model.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/add_project.dart';
import 'features/projects/domain/usecases/get_project_by_id.dart';
import 'features/projects/domain/usecases/get_projects.dart';
import 'features/projects/domain/usecases/update_project.dart';
import 'features/projects/presentation/providers/project_provider.dart';

/// Dependency Injection Container with Hive initialization
class InjectionContainer {
  static late SharedPreferences _sharedPreferences;

  /// Initialize dependencies including Hive
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(ProjectLocalModelAdapter());
    
    // External dependencies
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Get ProjectProvider with all dependencies
  static ProjectProvider getProjectProvider() {
    // Data sources
    final localDataSource = ProjectLocalDataSourceImpl();
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
