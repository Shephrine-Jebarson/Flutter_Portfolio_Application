/// Profile data model containing all user information
class Profile {
  final String name;
  final String role;
  final String bio;
  final String email;
  final String phone;
  final String location;
  final String college;
  final String cgpa;
  final String portfolioUrl;
  final List<String> skills;
  final List<Achievement> achievements;

  const Profile({
    required this.name,
    required this.role,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    required this.college,
    required this.cgpa,
    required this.portfolioUrl,
    required this.skills,
    required this.achievements,
  });
}

/// Achievement data model
class Achievement {
  final String title;
  final String description;

  const Achievement({
    required this.title,
    required this.description,
  });
}
