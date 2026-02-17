import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project_entity.dart';

/// Repository interface - Contract for project data operations
/// Implementation will be in data layer
abstract class ProjectRepository {
  /// Get all projects
  Future<Either<Failure, List<ProjectEntity>>> getProjects();

  /// Add a new project
  Future<Either<Failure, void>> addProject(ProjectEntity project);

  /// Update existing project
  Future<Either<Failure, void>> updateProject(ProjectEntity project);

  /// Get project by ID
  Future<Either<Failure, ProjectEntity>> getProjectById(int id);
}
