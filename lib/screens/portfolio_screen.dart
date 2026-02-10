import 'package:flutter/material.dart';
import '../profile/profile.dart';
import '../profile/widgets/profile_header.dart';
import '../profile/widgets/project_counter.dart';
import '../profile/widgets/skills_section.dart';
import '../profile/widgets/achievements_section.dart';
import '../profile/widgets/contact_info.dart';
import '../widgets/portfolio_projects_section.dart';
import '../providers/theme_provider.dart';
import '../theme/app_spacing.dart';
import 'package:provider/provider.dart';
import 'project_list_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _projectCount = 3;

  final Profile _profile = const Profile(
    name: 'Shephrine Jebarson',
    role: 'Flutter Developer Intern',
    bio: 'Currently working as a Flutter Developer Intern, I focus on building clean, responsive, and user-friendly mobile applications. I enjoy turning ideas into functional interfaces and continuously improving my skills by working on real-world projects using Flutter and Dart.',
    email: 'shephrinejebarson@gmail.com',
    phone: '+91 7358183938',
    location: '38c, Janakiraman street, Selaiyur, Chennai',
    college: 'Rajalakshmi Engineering College',
    cgpa: '8.2',
    portfolioUrl: 'https://mellifluous-dragon-fba241.netlify.app/',
    skills: [
      'Java', 'C/C++', 'HTML/CSS', 'MySQL', 'Flutter',
      'Dart', 'Problem Solving', 'Leadership', 'Communication', 'Team Work',
    ],
    achievements: [
      Achievement(
        title: 'HappyFox Hackathon Finalist',
        description: 'Reached finals in competitive hackathon showcasing innovative solutions',
      ),
      Achievement(
        title: 'X-plore Innovation Contest Runner-up',
        description: 'Second place in innovation competition for creative problem solving',
      ),
      Achievement(
        title: 'Media Manager - EDC',
        description: 'Led media operations for Entrepreneurship Development Cell',
      ),
    ],
  );

  void _increaseCount() {
    setState(() {
      _projectCount++;
    });
  }

  void _resetCount() {
    setState(() {
      _projectCount = 0;
    });
  }

  void _navigateToProjects() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProjectListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 800 ? 60.0 : AppSpacing.lg;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0f0f23) : const Color(0xFFBBDEFB),
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                onPressed: themeProvider.toggleTheme,
                icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
              );
            },
          ),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppSpacing.lg),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                ProfileHeader(profile: _profile),
                SizedBox(height: AppSpacing.xl),
                SkillsSection(skills: _profile.skills),
                SizedBox(height: AppSpacing.xxl),
                PortfolioProjectsSection(onViewProjects: _navigateToProjects),
                SizedBox(height: AppSpacing.xxl),
                AchievementsSection(achievements: _profile.achievements),
                SizedBox(height: AppSpacing.xxl),
                ContactInfo(profile: _profile),
                SizedBox(height: AppSpacing.xxl),
                ProjectCounter(
                  count: _projectCount,
                  onIncrease: _increaseCount,
                  onReset: _resetCount,
                ),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}