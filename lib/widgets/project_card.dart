import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/projects/domain/entities/project_entity.dart';
import '../theme/app_spacing.dart';

class ProjectCard extends StatefulWidget {
  final ProjectEntity project;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.onEdit,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.project.isCompleted;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.project.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (widget.onEdit != null)
                    IconButton(
                      onPressed: widget.onEdit,
                      icon: Icon(Icons.edit, color: isDark ? theme.colorScheme.primary : const Color(0xFF0D47A1), size: 20),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? (isDark ? theme.colorScheme.primary.withOpacity(0.2) : const Color(0xFF1976D2).withOpacity(0.3))
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isCompleted 
                            ? (isDark ? theme.colorScheme.primary : const Color(0xFF0D47A1))
                            : (isDark ? Colors.orange : const Color(0xFFE65100)),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.project.status,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isCompleted 
                            ? (isDark ? theme.colorScheme.primary : const Color(0xFF0D47A1))
                            : (isDark ? Colors.orange : const Color(0xFFE65100)),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                widget.project.category,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? theme.colorScheme.primary : const Color(0xFF0D47A1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                widget.project.description,
                maxLines: isExpanded ? null : 3,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...widget.project.techStack.split(', ').map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          fontSize: 12,
                          color: isDark ? Colors.blue.shade300 : const Color(0xFF0D47A1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.project.platform,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDark ? Colors.purple.shade300 : const Color(0xFF6A1B9A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[ 
                SizedBox(height: AppSpacing.md),
                Text(
                  'Highlights:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  widget.project.highlights,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
              if (!isExpanded) SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
