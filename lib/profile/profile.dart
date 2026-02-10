// Data models for the profile application
// Contains Profile and Achievement classes to structure user information

// Main profile data model containing all user information
class Profile {
  // Personal information fields
  final String name;        // Full name of the user
  final String role;        // Current job title/position
  final String bio;         // Short biography (2-3 lines)
  final String email;       // Contact email address
  final String phone;       // Phone number
  final String location;    // Physical address
  
  // Educational information
  final String college;     // College/University name
  final String cgpa;        // Academic performance
  
  // Professional information
  final String portfolioUrl; // Personal website/portfolio link
  final List<String> skills; // Technical and soft skills list
  final List<Achievement> achievements; // List of accomplishments

  // Constructor with required parameters for creating Profile instances
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

// Achievement data model for storing accomplishment information
class Achievement {
  final String title;       // Achievement title/name
  final String description; // Detailed description of the achievement

  // Constructor for creating Achievement instances
  const Achievement({
    required this.title,
    required this.description,
  });
}