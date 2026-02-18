import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../features/projects/presentation/providers/project_provider.dart';
import '../../../widgets/project_card.dart';
import '../../../widgets/empty_state.dart';
import 'project_detail_screen.dart';
import 'add_project_screen.dart';

/// Project list screen with pagination
class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProjectProvider>().loadMoreProjects();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _AppBar(isDark: isDark),
              Expanded(child: _ProjectList(scrollController: _scrollController)),
            ],
          ),
        ),
      ),
      floatingActionButton: const _AddProjectButton(),
    );
  }
}

/// Custom app bar with back button and project count
class _AppBar extends StatelessWidget {
  final bool isDark;
  
  const _AppBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final projectCount = context.select<ProjectProvider, int>((p) => p.projectCount);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: isDark ? Colors.white : const Color(0xFF0D47A1),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Projects',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0D47A1),
                  ),
                ),
                Text(
                  '$projectCount projects completed',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.white.withOpacity(0.7) : const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Project list or empty state
class _ProjectList extends StatelessWidget {
  final ScrollController scrollController;
  
  const _ProjectList({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final projects = context.select<ProjectProvider, int>((p) => p.projects.length);
    
    return projects == 0 ? const _EmptyStateWithPosts() : _ProjectGrid(scrollController: scrollController);
  }
}

/// Empty state
class _EmptyStateWithPosts extends StatelessWidget {
  const _EmptyStateWithPosts();

  @override
  Widget build(BuildContext context) {
    return const EmptyState();
  }
}

/// Grid of project cards with pagination
class _ProjectGrid extends StatelessWidget {
  final ScrollController scrollController;
  
  const _ProjectGrid({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: provider.projects.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == provider.projects.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final project = provider.projects[index];
            return ProjectCard(
              key: ValueKey(project.id),
              project: project,
              onTap: () => _navigateToDetail(context, project),
              onEdit: () => _navigateToEdit(context, project),
            ).animate(delay: (index * 100).ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }
  
  void _navigateToDetail(BuildContext context, project) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProjectDetailScreen(project: project),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
  
  void _navigateToEdit(BuildContext context, project) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddProjectScreen(project: project),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

/// Floating action button to add projects
class _AddProjectButton extends StatelessWidget {
  const _AddProjectButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddProjectScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                )),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      backgroundColor: const Color(0xFF00d4ff),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: Text(
        'Add Project',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }
}