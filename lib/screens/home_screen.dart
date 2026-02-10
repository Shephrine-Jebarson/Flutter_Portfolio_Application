import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_spacing.dart';
import 'portfolio_screen.dart';

/// Home screen widget - Landing page of the portfolio app
/// Features profile information, animated elements, and navigation to projects
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Animation controllers for smooth entrance animations
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animations for smooth entrance effects
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
    
    // Start the entrance animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? AppSpacing.xl : AppSpacing.lg;
    
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
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
                            
                            // Theme Toggle Button
                            Align(
                              alignment: Alignment.topRight,
                              child: Consumer<ThemeProvider>(
                                builder: (context, themeProvider, _) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isDark 
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.black.withOpacity(0.1),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: themeProvider.toggleTheme,
                                      icon: Icon(
                                        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                      tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            // Profile Section
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  children: [
                                    // Profile Image
                                    Container(
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
                                                  child: const Icon(
                                                    Icons.person,
                                                    size: 60,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    SizedBox(height: AppSpacing.lg),
                                    
                                    // Name
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: isDark
                                            ? [const Color(0xFF00d4ff), const Color(0xFFffffff)]
                                            : [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
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
                                    ),
                                    
                                    SizedBox(height: AppSpacing.md),
                                    
                                    // Animated Title
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFF00d4ff),
                                          width: 1.5,
                                        ),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Description Card
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isDark 
                                    ? Colors.white.withOpacity(0.1)
                                    : const Color(0xFF64B5F6).withOpacity(0.3),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.2)
                                      : const Color(0xFF1565C0).withOpacity(0.3),
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
                                  
                                  // College Info
                                  Row(
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
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // CGPA
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
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
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
                            
                            // Quick Stats
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatCard('${projectProvider.projectCount}', 'Projects', Icons.code),
                                _buildStatCard('${projectProvider.uniqueLanguages.length}', 'Languages', Icons.language),
                                _buildStatCard('${projectProvider.uniquePlatforms.length}', 'Platforms', Icons.devices),
                              ],
                            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3, end: 0),
                            
                            // Explore Projects Button
                            Container(
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
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const PortfolioScreen(),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
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
                            ).animate().fadeIn(delay: 900.ms).scale(begin: const Offset(0.8, 0.8)),
                            
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
      },
    );
  }

  Widget _buildStatCard(String number, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : const Color(0xFF64B5F6).withOpacity(0.3),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : const Color(0xFF1565C0).withOpacity(0.3),
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