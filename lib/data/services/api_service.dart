import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/contact_message.dart';

/// API service for handling network requests
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetches paginated posts from API
  /// 
  /// [page] - Page number (1-indexed)
  /// [limit] - Number of items per page
  static Future<List<Post>> fetchPosts({int page = 1, int limit = 10}) async {
    try {
      final start = (page - 1) * limit;
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_start=$start&_limit=$limit'),
        headers: {
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Sends contact message to API
  static Future<ContactMessage> sendContactMessage(ContactMessage message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
        },
        body: json.encode(message.toJson()),
      );
      
      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return ContactMessage.fromJson(jsonData);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
