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
    await _prefs!.setString(_projectsKey, jsonString);
  }

  static Future<List<Project>> loadProjects() async {
    await _initPrefs();
    final jsonString = _prefs!.getString(_projectsKey);
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Project.fromJson(json)).toList();
  }
}
