import 'package:hive/hive.dart';
import '../models/project_local_model.dart';

/// Local data source for project storage using Hive
abstract class ProjectLocalDataSource {
  Future<List<ProjectLocalModel>> getCachedProjects();
  Future<void> cacheProjects(List<ProjectLocalModel> projects);
  Future<void> clearCache();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  static const String _boxName = 'projects';
  
  @override
  Future<List<ProjectLocalModel>> getCachedProjects() async {
    final box = await Hive.openBox<ProjectLocalModel>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheProjects(List<ProjectLocalModel> projects) async {
    final box = await Hive.openBox<ProjectLocalModel>(_boxName);
    await box.clear();
    for (var project in projects) {
      await box.put(project.id, project);
    }
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox<ProjectLocalModel>(_boxName);
    await box.clear();
  }
}
