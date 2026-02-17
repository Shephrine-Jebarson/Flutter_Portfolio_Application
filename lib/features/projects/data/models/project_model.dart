import '../../domain/entities/project_entity.dart';

/// Project Model - Data transfer object with JSON serialization
/// Extends ProjectEntity to inherit business logic
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.category,
    required super.description,
    required super.techStack,
    required super.platform,
    required super.status,
    required super.githubLink,
    required super.highlights,
  });

  /// Convert Model to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'techStack': techStack,
        'platform': platform,
        'status': status,
        'githubLink': githubLink,
        'highlights': highlights,
      };

  /// Create Model from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json['id'] as int,
        title: json['title'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        techStack: json['techStack'] as String,
        platform: json['platform'] as String,
        status: json['status'] as String,
        githubLink: json['githubLink'] as String,
        highlights: json['highlights'] as String,
      );

  /// Convert Entity to Model
  factory ProjectModel.fromEntity(ProjectEntity entity) => ProjectModel(
        id: entity.id,
        title: entity.title,
        category: entity.category,
        description: entity.description,
        techStack: entity.techStack,
        platform: entity.platform,
        status: entity.status,
        githubLink: entity.githubLink,
        highlights: entity.highlights,
      );
}
