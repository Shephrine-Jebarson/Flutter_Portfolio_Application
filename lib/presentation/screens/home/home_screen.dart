import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../theme/app_spacing.dart';
import '../portfolio/portfolio_screen.dart';

/// Home screen - Landing page with profile overview
/// 
/// Optimized with:
/// - Selector for granular rebuilds
/// - Extracted const widgets
/// - Minimal rebuild scope
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? AppSpacing.xl : AppSpacing.lg;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: AppSpacing.md),
                        const _ThemeToggle(),
                        _ProfileSection(
                          fadeAnimation: _fadeAnimation,
                          slideAnimation: _slideAnimation,
                          isDark: isDark,
                        ),
                        _DescriptionCard(isDark: isDark).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
                        const _StatsRow().animate().fadeIn(delay: 700.ms).slideY(begin: 0.3, end: 0),
                        _ExploreButton(isDark: isDark).animate().fadeIn(delay: 900.ms).scale(begin: const Offset(0.8, 0.8)),
                        SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Theme toggle button - Only rebuilds when theme changes
class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Only rebuilds when isDarkMode changes
    final isDarkMode = context.select<ThemeProvider, bool>((p) => p.isDarkMode);
    
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
          ),
        ),
        child: IconButton(
          onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? Colors.white : Colors.black87,
          ),
          tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
        ),
      ),
    );
  }
}

/// Profile section with animated entrance
class _ProfileSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final bool isDark;

  const _ProfileSection({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          children: [
            const _ProfileImage(),
            SizedBox(height: AppSpacing.lg),
            _ProfileName(isDark: isDark),
            SizedBox(height: AppSpacing.md),
            _AnimatedTitle(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

/// Profile image with gradient border
class _ProfileImage extends StatelessWidget {
  const _ProfileImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF00d4ff), Color(0xFF0099cc)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00d4ff).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Profile name with gradient shader
class _ProfileName extends StatelessWidget {
  final bool isDark;

  const _ProfileName({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: isDark
            ? const [Color(0xFF00d4ff), Color(0xFFffffff)]
            : const [Color(0xFF0D47A1), Color(0xFF1565C0)],
      ).createShader(bounds),
      child: Text(
        'Shephrine Jebarson',
        style: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Animated typewriter title
class _AnimatedTitle extends StatelessWidget {
  final bool isDark;

  const _AnimatedTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00d4ff), width: 1.5),
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            'Flutter Developer Intern',
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1),
              fontWeight: FontWeight.w500,
            ),
            speed: const Duration(milliseconds: 100),
          ),
        ],
        repeatForever: true,
        pause: const Duration(milliseconds: 2000),
      ),
    );
  }
}

/// Description card with bio and education info
class _DescriptionCard extends StatelessWidget {
  final bool isDark;

  const _DescriptionCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFF64B5F6).withOpacity(0.3),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.2) : const Color(0xFF1565C0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Flutter Developer Intern focused on building clean, responsive mobile applications. Passionate about turning ideas into functional interfaces.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF0D47A1),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _CollegeInfo(isDark: isDark),
          const SizedBox(height: 8),
          _CGPAInfo(isDark: isDark),
        ],
      ),
    );
  }
}

/// College information row
class _CollegeInfo extends StatelessWidget {
  final bool isDark;

  const _CollegeInfo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.school,
          color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF1565C0),
          size: 16,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Rajalakshmi Engineering College',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.8) : const Color(0xFF0D47A1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// CGPA information row
class _CGPAInfo extends StatelessWidget {
  final bool isDark;

  const _CGPAInfo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 6),
        Text(
          'CGPA: 8.2',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? Colors.white.withOpacity(0.8) : const Color(0xFF0D47A1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Stats row - Only rebuilds when project stats change
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    // Only rebuilds when these specific values change
    final projectCount = context.select<ProjectProvider, int>((p) => p.projectCount);
    final languageCount = context.select<ProjectProvider, int>((p) => p.uniqueLanguages.length);
    final platformCount = context.select<ProjectProvider, int>((p) => p.uniquePlatforms.length);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatCard(number: '$projectCount', label: 'Projects', icon: Icons.code),
        _StatCard(number: '$languageCount', label: 'Languages', icon: Icons.language),
        _StatCard(number: '$platformCount', label: 'Platforms', icon: Icons.devices),
      ],
    );
  }
}

/// Individual stat card widget
class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFF64B5F6).withOpacity(0.3),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.2) : const Color(0xFF1565C0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF1565C0),
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0D47A1),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark ? Colors.white.withOpacity(0.7) : const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }
}

/// Explore button with navigation
class _ExploreButton extends StatelessWidget {
  final bool isDark;

  const _ExploreButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF00d4ff), Color(0xFF0099cc)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00d4ff).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const PortfolioScreen(),
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
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Portfolio',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
