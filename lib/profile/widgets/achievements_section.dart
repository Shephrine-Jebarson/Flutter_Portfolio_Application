import 'package:flutter/material.dart';
import '../profile.dart';

class AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsSection({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Text(
          'Achievements',
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
            color: const Color(0xFFffd700),
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
          childAspectRatio: 1.3,
          children: achievements.map((achievement) => _buildAchievementCard(achievement)).toList(),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFF90CAF9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFffd700).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFffd700).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFffd700),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFffd700),
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF0D47A1),
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}