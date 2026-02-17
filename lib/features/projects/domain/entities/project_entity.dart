import 'package:equatable/equatable.dart';

/// Project entity - Pure business object
/// No JSON serialization, no framework dependencies
class ProjectEntity extends Equatable {
  final int id;
  final String title;
  final String category;
  final String description;
  final String techStack;
  final String platform;
  final String status;
  final String githubLink;
  final String highlights;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.techStack,
    required this.platform,
    required this.status,
    required this.githubLink,
    required this.highlights,
  });

  bool get isCompleted => status == 'Completed';

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        description,
        techStack,
        platform,
        status,
        githubLink,
        highlights,
      ];
}
