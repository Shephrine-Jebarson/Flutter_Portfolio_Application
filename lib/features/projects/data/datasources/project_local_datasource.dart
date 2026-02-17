import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/project_model.dart';

/// Contract for local data source
abstract class ProjectLocalDataSource {
  Future<List<ProjectModel>> getCachedProjects();
  Future<void> cacheProjects(List<ProjectModel> projects);
}

/// Implementation of local data source using SharedPreferences
class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedProjectsKey = 'CACHED_PROJECTS';

  ProjectLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProjectModel>> getCachedProjects() async {
    final jsonString = sharedPreferences.getString(cachedProjectsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw CacheException('No cached data found');
    }
  }

  @override
  Future<void> cacheProjects(List<ProjectModel> projects) async {
    final jsonList = projects.map((project) => project.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(cachedProjectsKey, jsonString);
  }
}
