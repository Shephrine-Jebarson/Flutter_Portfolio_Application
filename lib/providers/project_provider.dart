import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/sample_data.dart';
import '../services/storage_service.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoaded = false;

  List<Project> get projects => _projects;

  Future<void> loadProjects() async {
    if (_isLoaded) return;
    print('🚀 Loading projects on app startup...');
    final saved = await StorageService.loadProjects();
    _projects = saved.isEmpty ? List.from(sampleProjects) : saved;
    _isLoaded = true;
    print('✅ Projects loaded: ${_projects.length} projects');
    notifyListeners();
  }

  int get projectCount => _projects.length;

  Set<String> get uniqueLanguages {
    return _projects
        .map((p) => p.techStack.split(',').map((e) => e.trim()))
        .expand((e) => e)
        .where((lang) => lang.isNotEmpty)
        .toSet();
  }

  Set<String> get uniquePlatforms {
    return _projects.map((p) => p.platform).where((p) => p.isNotEmpty).toSet();
  }

  Future<void> addProject(Project project) async {
    _projects.add(project);
    notifyListeners();
    await StorageService.saveProjects(_projects);
  }

  Future<void> updateProject(Project updatedProject) async {
    final index = _projects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      print('🔄 Updating project: ${updatedProject.title} (Status: ${updatedProject.status})');
      _projects[index] = updatedProject;
      notifyListeners();
      await StorageService.saveProjects(_projects);
      print('✅ Project updated and saved');
    }
  }

  Project? getProjectById(int id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }
}