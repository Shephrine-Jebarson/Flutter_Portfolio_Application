import 'package:flutter/foundation.dart';
import '../data/models/post.dart';
import '../data/services/api_service.dart';

/// Manages paginated post loading with state handling
/// 
/// Handles:
/// - Initial and pagination loading states
/// - Error handling with retry
/// - Duplicate request prevention
/// - End-of-data detection
class PaginationProvider extends ChangeNotifier {
  List<Post> _posts = [];
  PaginationState _state = PaginationState.initial;
  String? _error;
  
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Getters
  List<Post> get posts => _posts;
  PaginationState get state => _state;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  /// Loads initial page of posts
  Future<void> loadInitialPosts() async {
    if (_state == PaginationState.loading) return;
    
    _state = PaginationState.loading;
    _error = null;
    notifyListeners();

    try {
      final posts = await ApiService.fetchPosts(page: 1, limit: _pageSize);
      _posts = posts;
      _currentPage = 1;
      _hasMore = posts.length == _pageSize;
      _state = PaginationState.loaded;
    } catch (e) {
      _error = e.toString();
      _state = PaginationState.error;
    }
    notifyListeners();
  }

  /// Loads next page of posts
  Future<void> loadMorePosts() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newPosts = await ApiService.fetchPosts(
        page: _currentPage + 1,
        limit: _pageSize,
      );
      
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _posts.addAll(newPosts);
        _currentPage++;
        _hasMore = newPosts.length == _pageSize;
      }
    } catch (e) {
      // Silent fail for pagination, don't disrupt user experience
      debugPrint('Pagination error: $e');
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Retries loading after error
  Future<void> retry() => loadInitialPosts();
}

/// Pagination state enum
enum PaginationState {
  initial,
  loading,
  loaded,
  error,
}
