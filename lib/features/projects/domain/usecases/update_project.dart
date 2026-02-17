import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

/// Parameters for updating a project
class UpdateProjectParams {
  final ProjectEntity project;

  const UpdateProjectParams(this.project);
}

/// Use case for updating an existing project
class UpdateProject extends UseCase<void, UpdateProjectParams> {
  final ProjectRepository repository;

  UpdateProject(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProjectParams params) async {
    return await repository.updateProject(params.project);
  }
}
