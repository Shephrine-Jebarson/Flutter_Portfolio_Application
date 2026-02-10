import 'package:flutter/material.dart';

class PortfolioProjectsSection extends StatelessWidget {
  final VoidCallback onViewProjects;

  const PortfolioProjectsSection({
    super.key,
    required this.onViewProjects,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Text(
          'My Projects',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF00d4ff),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 30),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.85,
          children: [
            _buildProjectCard(
              'Voting System',
              'Developed a simple voting system using C language, enabling users to cast votes securely and efficiently.',
              Icons.how_to_vote,
              ['C Language', 'Data Structures', 'Security'],
            ),
            _buildProjectCard(
              'Election Simulator',
              'Developed a console application in C++ to simulate classroom elections, focusing on implementing core OOP concepts.',
              Icons.group,
              ['C++', 'OOP', 'Console Application'],
            ),
            _buildProjectCard(
              'Class Pulse',
              'Developed an application aimed at fostering student engagement in classroom activities using AI tools.',
              Icons.school,
              ['AI Integration', 'Student Engagement', 'Interactive Features'],
            ),
          ],
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: onViewProjects,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00d4ff),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'View All Projects',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(String title, String description, IconData icon, List<String> tags) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFF90CAF9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00d4ff).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00d4ff).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1),
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : const Color(0xFF1565C0),
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00d4ff).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF00d4ff).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}