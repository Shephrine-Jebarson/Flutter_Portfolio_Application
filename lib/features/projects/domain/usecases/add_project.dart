import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

/// Parameters for adding a project
class AddProjectParams {
  final ProjectEntity project;

  const AddProjectParams(this.project);
}

/// Use case for adding a new project
class AddProject extends UseCase<void, AddProjectParams> {
  final ProjectRepository repository;

  AddProject(this.repository);

  @override
  Future<Either<Failure, void>> call(AddProjectParams params) async {
    return await repository.addProject(params.project);
  }
}
