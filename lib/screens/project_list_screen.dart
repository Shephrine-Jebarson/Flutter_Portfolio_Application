import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../widgets/empty_state.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'project_detail_screen.dart';
import 'add_project_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1a1a2e),
                        const Color(0xFF16213e),
                        const Color(0xFF0f3460),
                      ]
                    : [
                        const Color(0xFFE3F2FD),
                        const Color(0xFFBBDEFB),
                        const Color(0xFF90CAF9),
                      ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom App Bar
                  Container(
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
                                '${projectProvider.projectCount} projects completed',
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
                  ),
                  
                  // Projects List
                  Expanded(
                    child: projectProvider.projects.isEmpty
                        ? Column(
                            children: [
                              const Expanded(child: EmptyState()),
                              // API Posts Section
                              Container(
                                height: 300,
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        'Latest API Posts',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FutureBuilder<List<Post>>(
                                        future: ApiService.fetchPosts(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'Error: ${snapshot.error}',
                                                style: const TextStyle(color: Colors.red),
                                              ),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            final posts = snapshot.data!.take(3).toList();
                                            return ListView.builder(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              itemCount: posts.length,
                                              itemBuilder: (context, index) {
                                                final post = posts[index];
                                                return Card(
                                                  margin: const EdgeInsets.only(bottom: 8),
                                                  color: Colors.white.withOpacity(0.1),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor: const Color(0xFF00d4ff),
                                                      child: Text('${post.id}'),
                                                    ),
                                                    title: Text(
                                                      post.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Text(
                                                      post.body,
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.7),
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          return const Center(
                                            child: Text(
                                              'No data available',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: projectProvider.projects.length,
                            itemBuilder: (context, index) {
                              final project = projectProvider.projects[index];
                              return ProjectCard(
                                project: project,
                                onTap: () {
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
                                },
                                onEdit: () {
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
                                },
                              ).animate(delay: (index * 100).ms)
                                  .fadeIn(duration: 600.ms)
                                  .slideX(begin: 0.3, end: 0);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
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
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}