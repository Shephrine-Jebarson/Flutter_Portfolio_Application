import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_datasource.dart';
import '../datasources/project_remote_datasource.dart';
import '../models/project_model.dart';
import '../models/project_local_model.dart';

/// Repository implementation with offline support
/// Syncs between remote API and local database
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      // Try remote first
      final remoteProjects = await remoteDataSource.getProjects();
      
      // Convert to local models and cache
      final localModels = remoteProjects
          .map((p) => ProjectLocalModel.fromEntity(p.toJson()))
          .toList();
      await localDataSource.cacheProjects(localModels);
      
      return Right(remoteProjects);
    } on ServerException {
      // Fallback to cache on network failure
      try {
        final cachedProjects = await localDataSource.getCachedProjects();
        final entities = cachedProjects
            .map((p) => ProjectModel.fromJson(p.toEntity()))
            .toList();
        return Right(entities);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, void>> addProject(ProjectEntity project) async {
    try {
      final currentProjects = await localDataSource.getCachedProjects();
      final newProject = ProjectLocalModel.fromEntity(
        ProjectModel.fromEntity(project).toJson(),
      );
      await localDataSource.cacheProjects([...currentProjects, newProject]);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProject(ProjectEntity project) async {
    try {
      final currentProjects = await localDataSource.getCachedProjects();
      final updatedProjects = currentProjects.map((p) {
        if (p.id == project.id) {
          return ProjectLocalModel.fromEntity(
            ProjectModel.fromEntity(project).toJson(),
          );
        }
        return p;
      }).toList();
      await localDataSource.cacheProjects(updatedProjects);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById(int id) async {
    try {
      final projects = await localDataSource.getCachedProjects();
      final project = projects.firstWhere((p) => p.id == id);
      return Right(ProjectModel.fromJson(project.toEntity()));
    } catch (e) {
      return Left(CacheFailure('Project not found'));
    }
  }
}
