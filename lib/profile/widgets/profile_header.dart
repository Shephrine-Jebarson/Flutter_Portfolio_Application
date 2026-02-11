import 'package:flutter/material.dart';
import '../profile.dart';

class ProfileHeader extends StatefulWidget {
  final Profile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1a1a2e), const Color(0xFF16213e), const Color(0xFF0f3460)]
                : [const Color(0xFF90CAF9), const Color(0xFF64B5F6), const Color(0xFF42A5F5)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: _ProfileInfo(profile: widget.profile, isDark: isDark),
            ),
            const SizedBox(width: 60),
            const _ProfileImage(),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final Profile profile;
  final bool isDark;

  const _ProfileInfo({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          profile.name,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0D47A1),
            letterSpacing: 1.2,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _RoleBadge(role: profile.role, isDark: isDark),
        const SizedBox(height: 20),
        Text(
          profile.bio,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white70 : const Color(0xFF1565C0),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          profile.college,
          style: TextStyle(
            fontSize: 18,
            color: isDark ? Colors.white70 : const Color(0xFF1565C0),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        _CGPADisplay(cgpa: profile.cgpa, isDark: isDark),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  final bool isDark;

  const _RoleBadge({required this.role, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00d4ff).withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF00d4ff), width: 1),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 18,
          color: isDark ? const Color(0xFF00d4ff) : const Color(0xFF0D47A1),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CGPADisplay extends StatelessWidget {
  final String cgpa;
  final bool isDark;

  const _CGPADisplay({required this.cgpa, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Color(0xFFffd700), size: 20),
        const SizedBox(width: 8),
        Text(
          'CGPA: $cgpa',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF0D47A1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF00d4ff), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00d4ff).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 122,
        backgroundImage: AssetImage('assets/images/profile_image.jpg'),
        backgroundColor: Color(0xFF2a2a4a),
      ),
    );
  }
}
