import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.code,
                  color: isDark ? theme.colorScheme.primary : const Color(0xFF0D47A1),
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                'Technical Skills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 1,
            ),
          ),
          child: Text(
            skill,
            style: TextStyle(
              color: isDark ? theme.colorScheme.primary : const Color(0xFF0D47A1),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}