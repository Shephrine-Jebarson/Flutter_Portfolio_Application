import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_datasource.dart';
import '../datasources/project_remote_datasource.dart';
import '../models/project_model.dart';

/// Repository implementation
/// Connects data sources to domain layer
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
      // Try to get from remote
      final remoteProjects = await remoteDataSource.getProjects();
      
      // Cache the projects
      await localDataSource.cacheProjects(remoteProjects);
      
      // Return as entities
      return Right(remoteProjects);
    } on ServerException catch (e) {
      // If remote fails, try cache
      try {
        final cachedProjects = await localDataSource.getCachedProjects();
        return Right(cachedProjects);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addProject(ProjectEntity project) async {
    try {
      // Get current projects
      final currentProjects = await localDataSource.getCachedProjects();
      
      // Add new project
      final newProject = ProjectModel.fromEntity(project);
      final updatedProjects = [...currentProjects, newProject];
      
      // Save to cache
      await localDataSource.cacheProjects(updatedProjects);
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProject(ProjectEntity project) async {
    try {
      // Get current projects
      final currentProjects = await localDataSource.getCachedProjects();
      
      // Update project
      final updatedProjects = currentProjects.map((p) {
        return p.id == project.id ? ProjectModel.fromEntity(project) : p;
      }).toList();
      
      // Save to cache
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
      return Right(project);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Project not found'));
    }
  }
}
