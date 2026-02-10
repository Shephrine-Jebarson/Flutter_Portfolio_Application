// Interactive project counter widget with star rating system
// This widget demonstrates state management, animations, and user interaction
// It serves as both a counter and a rating system with visual feedback

import 'package:flutter/material.dart';

// StatefulWidget that accepts counter value and callback functions from parent
class ProjectCounter extends StatefulWidget {
  final int count;              // Current counter value from parent
  final VoidCallback onIncrease; // Callback function to increment counter
  final VoidCallback onReset;    // Callback function to reset counter

  const ProjectCounter({
    super.key,
    required this.count,
    required this.onIncrease,
    required this.onReset,
  });

  @override
  State<ProjectCounter> createState() => _ProjectCounterState();
}

// State class with animation controllers for visual effects
class _ProjectCounterState extends State<ProjectCounter>
    with TickerProviderStateMixin {
  // Animation controllers for bounce and glow effects
  late AnimationController _bounceController; // Controls star bounce animation
  late AnimationController _glowController;   // Controls glow effect animation
  late Animation<double> _bounceAnimation;    // Bounce animation values
  late Animation<double> _glowAnimation;      // Glow animation values
  
  // Internal rating state (0-5 stars)
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    
    // Initialize bounce animation controller (300ms duration)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Initialize glow animation controller (800ms duration)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Create bounce animation that scales from 1.0 to 1.3
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    
    // Create glow animation that fades from 0.0 to 1.0
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // Clean up animation controllers to prevent memory leaks
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // Trigger both bounce and glow animations when rating changes
  void _animateRating() {
    // Start bounce animation and reverse it when complete
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    
    // Start glow animation and reverse it when complete
    _glowController.forward().then((_) {
      _glowController.reverse();
    });
  }

  // Increase rating by 1 (maximum 5 stars)
  void _increaseRating() {
    if (_rating < 5) {
      setState(() {
        _rating++; // Increment internal rating
      });
      _animateRating();        // Trigger animations
      widget.onIncrease();     // Call parent's increase function
    }
  }

  // Reset rating to 0 stars
  void _resetRating() {
    setState(() {
      _rating = 0; // Reset internal rating
    });
    widget.onReset(); // Call parent's reset function
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                ]
              : [
                  const Color(0xFF90CAF9),
                  const Color(0xFF64B5F6),
                ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFffd700).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFffd700).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section with icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Star icon in golden container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFffd700).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_rate,
                  color: Color(0xFFffd700),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Rate My Work',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFffd700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Star rating display with animations
          AnimatedBuilder(
            animation: _glowAnimation,
            // Generate 5 stars in a row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ScaleTransition(
                    // Apply bounce animation only to filled stars
                    scale: index < _rating ? _bounceAnimation : 
                           const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Add glow effect to filled stars
                        boxShadow: index < _rating ? [
                          BoxShadow(
                            color: const Color(0xFFffd700).withOpacity(
                              0.6 * _glowAnimation.value
                            ),
                            blurRadius: 15 * _glowAnimation.value,
                            spreadRadius: 3 * _glowAnimation.value,
                          ),
                        ] : [],
                      ),
                      child: Icon(
                        // Show filled or empty star based on rating
                        index < _rating ? Icons.star : Icons.star_border,
                        size: 50,
                        // Golden color for filled stars, gray for empty
                        color: index < _rating 
                            ? const Color(0xFFffd700)
                            : (isDark ? Colors.white30 : const Color(0xFF1565C0).withOpacity(0.3)),
                      ),
                    ),
                  ),
                );
              }),
            ),
            builder: (context, child) => child!,
          ),
          const SizedBox(height: 32),
          
          Text(
            _getRatingText(),
            style: TextStyle(
              fontSize: 18,
              color: _rating > 0 ? const Color(0xFFffd700) : (isDark ? Colors.white54 : const Color(0xFF1565C0)),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          
          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rate+ button (disabled when at 5 stars)
              _buildActionButton(
                onPressed: _increaseRating,
                icon: Icons.add_reaction,
                label: 'Rate +',
                color: const Color(0xFFffd700), // Golden color
                isEnabled: _rating < 5, // Disable at maximum rating
              ),
              // Reset button (disabled when at 0 stars)
              _buildActionButton(
                onPressed: _resetRating,
                icon: Icons.refresh,
                label: 'Reset',
                color: const Color(0xFFff6b6b), // Red color
                isEnabled: _rating > 0, // Disable when no rating
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Get appropriate feedback text based on current rating
  String _getRatingText() {
    switch (_rating) {
      case 0:
        return 'Click to rate my work!';
      case 1:
        return 'Thanks for the feedback!';
      case 2:
        return 'Appreciate it! Getting better!';
      case 3:
        return 'Great! Keep the momentum!';
      case 4:
        return 'Awesome! Almost perfect!';
      case 5:
        return 'Outstanding! You are amazing!';
      default:
        return '';
    }
  }

  // Helper method to build styled action buttons
  Widget _buildActionButton({
    required VoidCallback onPressed,  // Button callback function
    required IconData icon,           // Button icon
    required String label,            // Button text
    required Color color,             // Button color theme
    required bool isEnabled,          // Enable/disable state
  }) {
    return Container(
      // Custom border and gradient decoration
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          // Use color when enabled, gray when disabled
          color: isEnabled ? color : Colors.grey.shade600, 
          width: 2
        ),
        // Gradient background only when enabled
        gradient: isEnabled ? LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ) : null,
      ),
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null, // Disable when needed
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          foregroundColor: isEnabled ? color : Colors.grey.shade600,
          elevation: 0, // Flat design
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}