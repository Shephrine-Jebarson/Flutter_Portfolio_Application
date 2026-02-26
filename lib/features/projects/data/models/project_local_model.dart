import 'package:hive/hive.dart';

part 'project_local_model.g.dart';

/// Local database model for projects using Hive
@HiveType(typeId: 0)
class ProjectLocalModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String techStack;

  @HiveField(4)
  final String platform;

  @HiveField(5)
  final String? githubUrl;

  @HiveField(6)
  final String? liveUrl;

  @HiveField(7)
  final DateTime createdAt;

  ProjectLocalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.platform,
    this.githubUrl,
    this.liveUrl,
    required this.createdAt,
  });

  /// Convert to domain entity
  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'techStack': techStack,
      'platform': platform,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
    };
  }

  /// Create from domain entity
  factory ProjectLocalModel.fromEntity(Map<String, dynamic> entity) {
    return ProjectLocalModel(
      id: entity['id'] as int,
      title: entity['title'] as String,
      description: entity['description'] as String,
      techStack: entity['techStack'] as String,
      platform: entity['platform'] as String,
      githubUrl: entity['githubUrl'] as String?,
      liveUrl: entity['liveUrl'] as String?,
      createdAt: DateTime.now(),
    );
  }
}
