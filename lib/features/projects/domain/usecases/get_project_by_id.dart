import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

/// Parameters for getting a project by ID
class GetProjectByIdParams {
  final int id;

  const GetProjectByIdParams(this.id);
}

/// Use case for getting a project by ID
class GetProjectById extends UseCase<ProjectEntity, GetProjectByIdParams> {
  final ProjectRepository repository;

  GetProjectById(this.repository);

  @override
  Future<Either<Failure, ProjectEntity>> call(GetProjectByIdParams params) async {
    return await repository.getProjectById(params.id);
  }
}
