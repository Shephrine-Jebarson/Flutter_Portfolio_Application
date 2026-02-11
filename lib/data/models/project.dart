/// Project data model class
/// Contains all the information about a single project
class Project {
  final int id;
  final String title;
  final String category;
  final String description;
  final String techStack;
  final String platform;
  final String status;
  final String githubLink;
  final String highlights;

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
