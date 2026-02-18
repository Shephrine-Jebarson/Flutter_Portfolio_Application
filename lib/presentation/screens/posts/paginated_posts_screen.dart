import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/pagination_provider.dart';
import '../../../providers/theme_provider.dart';

/// Paginated posts screen with infinite scroll
class PaginatedPostsScreen extends StatefulWidget {
  const PaginatedPostsScreen({super.key});

  @override
  State<PaginatedPostsScreen> createState() => _PaginatedPostsScreenState();
}

class _PaginatedPostsScreenState extends State<PaginatedPostsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaginationProvider>().loadInitialPosts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PaginationProvider>().loadMorePosts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0f0f23) : const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('API Posts'),
        actions: const [_ThemeToggle()],
      ),
      body: _PostsList(scrollController: _scrollController),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<ThemeProvider, bool>((p) => p.isDarkMode);
    
    return IconButton(
      onPressed: () => context.read<ThemeProvider>().toggleTheme(),
      icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
    );
  }
}

class _PostsList extends StatelessWidget {
  final ScrollController scrollController;
  
  const _PostsList({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final state = context.select<PaginationProvider, PaginationState>((p) => p.state);
    
    switch (state) {
      case PaginationState.initial:
      case PaginationState.loading:
        return const Center(child: CircularProgressIndicator());
      case PaginationState.error:
        return const _ErrorView();
      case PaginationState.loaded:
        return _LoadedView(scrollController: scrollController);
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    final error = context.select<PaginationProvider, String?>((p) => p.error);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark ? Colors.red[300] : Colors.red[700],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load posts',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'Unknown error',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<PaginationProvider>().retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final ScrollController scrollController;
  
  const _LoadedView({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaginationProvider>(
      builder: (context, provider, _) {
        final posts = provider.posts;
        
        if (posts.isEmpty) {
          return Center(
            child: Text(
              'No posts available',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          );
        }
        
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: posts.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _PostCard(
              key: ValueKey(posts[index].id),
              post: posts[index],
            );
          },
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final dynamic post;
  
  const _PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? const Color(0xFF1a1a2e) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF00d4ff),
                  radius: 16,
                  child: Text(
                    '${post.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.body,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
