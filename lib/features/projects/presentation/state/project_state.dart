import 'package:equatable/equatable.dart';
import '../../domain/entities/project_entity.dart';

/// Base state class for projects
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

/// Loading state
class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

/// Success state with data
class ProjectLoaded extends ProjectState {
  final List<ProjectEntity> projects;

  const ProjectLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

/// Error state with message
class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Operation success state (for add/update)
class ProjectOperationSuccess extends ProjectState {
  final String message;

  const ProjectOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
