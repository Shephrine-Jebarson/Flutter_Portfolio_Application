/// Project data model class
/// Contains all the information about a single project
class Project {
  final int id; // Unique identifier for the project
  final String title; // Project name/title
  final String category; // Project category (e.g., "Web Development")
  final String description; // Brief description of the project
  final String techStack; // Technologies used (comma-separated)
  final String platform; // Target platform (e.g., "Web", "Mobile")
  final String status; // Current status ("Completed" or "In Progress")
  final String githubLink; // GitHub repository URL
  final String highlights; // Key achievements/features

  /// Constructor for creating a new Project instance
  const Project({
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

  /// Helper getter to check if project is completed
  /// Returns true if status is "Completed", false otherwise
  bool get isCompleted => status == 'Completed';

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

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    description: json['description'],
    techStack: json['techStack'],
    platform: json['platform'],
    status: json['status'],
    githubLink: json['githubLink'],
    highlights: json['highlights'],
  );
}