import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class StorageService {
  static const String _projectsKey = 'flutter.projects';
  static SharedPreferences? _prefs;

  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveProjects(List<Project> projects) async {
    await _initPrefs();
    final jsonList = projects.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final success = await _prefs!.setString(_projectsKey, jsonString);
    print('✅ Saved ${projects.length} projects to storage (success: $success)');
    print('📦 Data: ${jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}...');
    // Verify save
    final verify = _prefs!.getString(_projectsKey);
    print('🔍 Verification: ${verify != null ? "Data exists" : "Data NOT saved!"}');
  }

  static Future<List<Project>> loadProjects() async {
    await _initPrefs();
    print('📂 Loading projects from storage...');
    print('🔑 Using key: $_projectsKey');
    final jsonString = _prefs!.getString(_projectsKey);
    if (jsonString == null) {
      print('⚠️ No saved data found');
      return [];
    }
    print('✅ Found saved data: ${jsonString.substring(0, jsonString.length > 100 ? 100 : jsonString.length)}...');
    final jsonList = jsonDecode(jsonString) as List;
    final projects = jsonList.map((json) => Project.fromJson(json)).toList();
    print('✅ Loaded ${projects.length} projects');
    return projects;
  }
}
