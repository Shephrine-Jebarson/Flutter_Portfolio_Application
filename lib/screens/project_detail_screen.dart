import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/project.dart';
import '../models/sample_data.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isCompleted = project.isCompleted;
    final details = projectDetails[project.id] ?? {};
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
                      child: Text(
                        project.title,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0D47A1),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Header Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFF64B5F6).withOpacity(0.3),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.2) : const Color(0xFF1565C0).withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project.category,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isCompleted 
                                        ? (isDark ? const Color(0xFF00d4ff).withOpacity(0.2) : const Color(0xFF1976D2).withOpacity(0.3))
                                        : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isCompleted 
                                          ? (isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1))
                                          : (isDark ? Colors.orange : const Color(0xFFE65100)),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    project.status,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: isCompleted 
                                          ? (isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1))
                                          : (isDark ? Colors.orange : const Color(0xFFE65100)),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                      
                      const SizedBox(height: 24),
                      
                      _buildSection(context, 'Overview', details['overview'] ?? project.description, 400),
                      _buildSection(context, 'Problem Statement', details['problem'] ?? '', 600),
                      _buildSection(context, 'Solution', details['solution'] ?? '', 800),
                      _buildTechSection(context, 1000),
                      _buildSection(context, 'Key Features', details['features'] ?? project.highlights, 1200),
                      _buildSection(context, 'Learning Outcome', details['learning'] ?? '', 1400),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, int delay) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool shouldShowAsBullets = title == 'Key Features' || title == 'Learning Outcome';
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFF64B5F6).withOpacity(0.3),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFF1565C0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 12),
          shouldShowAsBullets ? _buildBulletPoints(content, isDark) : Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.8) : const Color(0xFF1565C0),
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildBulletPoints(String content, bool isDark) {
    List<String> points = content.split('•').where((point) => point.trim().isNotEmpty).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, right: 12),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF00d4ff),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                point.trim(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.white.withOpacity(0.8) : const Color(0xFF1565C0),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildTechSection(BuildContext context, int delay) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFF64B5F6).withOpacity(0.3),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFF1565C0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technologies Used',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...project.techStack.split(', ').map(
                (tech) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.blue.shade300 : const Color(0xFF0D47A1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Platform: ${project.platform}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.purple.shade300 : const Color(0xFF6A1B9A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.3, end: 0);
  }
}