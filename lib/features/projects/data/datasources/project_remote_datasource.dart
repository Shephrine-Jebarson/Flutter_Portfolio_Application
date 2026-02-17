import '../../../../core/error/exceptions.dart';
import '../models/project_model.dart';

/// Contract for remote data source
abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
}

/// Implementation of remote data source
/// Using sample data (can be replaced with actual API calls)
class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  @override
  Future<List<ProjectModel>> getProjects() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return sample projects
      return _sampleProjects;
    } catch (e) {
      throw ServerException('Failed to fetch projects: $e');
    }
  }
}

/// Sample project data
final List<ProjectModel> _sampleProjects = [
  const ProjectModel(
    id: 1,
    title: "Voting System",
    category: "System Programming",
    description: "A secure and efficient voting system allowing users to cast votes reliably. Designed with a focus on simplicity, accuracy, and controlled input handling.",
    techStack: "C",
    platform: "Console Application",
    status: "Completed",
    githubLink: "https://github.com/yourusername/voting-system",
    highlights: "Input validation, structured logic, secure vote counting",
  ),
  const ProjectModel(
    id: 2,
    title: "Election Simulator",
    category: "Object-Oriented Programming",
    description: "A console-based classroom election simulator implementing core OOP principles such as classes, objects, inheritance, and encapsulation.",
    techStack: "C++",
    platform: "Console Application",
    status: "Completed",
    githubLink: "https://github.com/yourusername/election-simulator",
    highlights: "OOP design, modular code, data handling",
  ),
  const ProjectModel(
    id: 3,
    title: "Class Pulse",
    category: "EdTech Application",
    description: "An application designed to enhance student engagement in classroom activities through interactive feedback and participation features, supported by AI tools.",
    techStack: "AI Tools, Web Technologies",
    platform: "Web / Application",
    status: "Completed",
    githubLink: "https://github.com/yourusername/class-pulse",
    highlights: "Student engagement, interactive features, AI integration",
  ),
  const ProjectModel(
    id: 4,
    title: "MeetWise.AI",
    category: "AI Automation",
    description: "An AI-powered meeting assistant built on the Workato platform that summarizes Google Meet sessions, emails summaries to participants, and automatically updates tasks in Jira.",
    techStack: "Workato, OpenAI, Jira API",
    platform: "Automation Platform",
    status: "In Progress",
    githubLink: "https://github.com/yourusername/meetwise-ai",
    highlights: "Meeting summarization, workflow automation, task tracking",
  ),
  const ProjectModel(
    id: 5,
    title: "DigiBus",
    category: "Smart Campus Solution",
    description: "A smart transportation management system for college campuses featuring real-time GPS tracking, WebSocket-based updates, geofencing alerts, and an admin monitoring dashboard.",
    techStack: "React, WebSocket, GPS, PWA",
    platform: "Progressive Web Application",
    status: "In Progress",
    githubLink: "https://github.com/yourusername/digibus",
    highlights: "Live tracking, ETA prediction, geofencing alerts, scalable architecture",
  ),
];
