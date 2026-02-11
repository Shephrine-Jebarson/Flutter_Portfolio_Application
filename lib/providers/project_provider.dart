import 'package:flutter/foundation.dart';
import '../data/models/project.dart';
import '../data/models/sample_data.dart';
import '../data/services/storage_service.dart';

/// Manages project state and provides computed statistics
/// 
/// Handles loading, adding, and updating projects with persistence.
/// Provides computed properties for analytics like unique languages
/// and platforms used across all projects.
class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoaded = false;

  /// All projects in the portfolio
  List<Project> get projects => _projects;
  
  /// Total number of projects
  int get projectCount => _projects.length;

  /// Set of unique programming languages/technologies used
  Set<String> get uniqueLanguages {
    return _projects
        .map((p) => p.techStack.split(',').map((e) => e.trim()))
        .expand((e) => e)
        .where((lang) => lang.isNotEmpty)
        .toSet();
  }

  /// Set of unique platforms targeted
  Set<String> get uniquePlatforms {
    return _projects.map((p) => p.platform).where((p) => p.isNotEmpty).toSet();
  }

  /// Loads projects from storage or initializes with sample data
  /// 
  /// Only loads once to prevent redundant operations.
  /// Call during app initialization.
  Future<void> loadProjects() async {
    if (_isLoaded) return;
    final saved = await StorageService.loadProjects();
    _projects = saved.isEmpty ? List.from(sampleProjects) : saved;
    _isLoaded = true;
    notifyListeners();
  }

  /// Adds a new project and persists to storage
  Future<void> addProject(Project project) async {
    _projects.add(project);
    notifyListeners();
    await StorageService.saveProjects(_projects);
  }

  /// Updates an existing project and persists changes
  Future<void> updateProject(Project updatedProject) async {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
      await StorageService.saveProjects(_projects);
    }
  }

  /// Retrieves a project by ID, returns null if not found
  Project? getProjectById(int id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }
}
