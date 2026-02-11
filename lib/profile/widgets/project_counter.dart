import 'package:flutter/material.dart';

class ProjectCounter extends StatefulWidget {
  final int count;
  final VoidCallback onIncrease;
  final VoidCallback onReset;

  const ProjectCounter({
    super.key,
    required this.count,
    required this.onIncrease,
    required this.onReset,
  });

  @override
  State<ProjectCounter> createState() => _ProjectCounterState();
}

class _ProjectCounterState extends State<ProjectCounter> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _animateRating() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    _glowController.forward().then((_) => _glowController.reverse());
  }

  void _increaseRating() {
    if (_rating < 5) {
      setState(() => _rating++);
      _animateRating();
      widget.onIncrease();
    }
  }

  void _resetRating() {
    setState(() => _rating = 0);
    widget.onReset();
  }

  String _getRatingText() {
    const texts = [
      'Click to rate my work!',
      'Thanks for the feedback!',
      'Appreciate it! Getting better!',
      'Great! Keep the momentum!',
      'Awesome! Almost perfect!',
      'Outstanding! You are amazing!',
    ];
    return texts[_rating];
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
              ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
              : [const Color(0xFF90CAF9), const Color(0xFF64B5F6)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFffd700).withOpacity(0.3), width: 2),
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
          const _Header(),
          const SizedBox(height: 32),
          _StarRating(
            rating: _rating,
            bounceAnimation: _bounceAnimation,
            glowAnimation: _glowAnimation,
            isDark: isDark,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                onPressed: _increaseRating,
                icon: Icons.add_reaction,
                label: 'Rate +',
                color: const Color(0xFFffd700),
                isEnabled: _rating < 5,
              ),
              _ActionButton(
                onPressed: _resetRating,
                icon: Icons.refresh,
                label: 'Reset',
                color: const Color(0xFFff6b6b),
                isEnabled: _rating > 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFffd700).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.star_rate, color: Color(0xFFffd700), size: 28),
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
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final Animation<double> bounceAnimation;
  final Animation<double> glowAnimation;
  final bool isDark;

  const _StarRating({
    required this.rating,
    required this.bounceAnimation,
    required this.glowAnimation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ScaleTransition(
              scale: index < rating ? bounceAnimation : const AlwaysStoppedAnimation(1.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: index < rating ? [
                    BoxShadow(
                      color: const Color(0xFFffd700).withOpacity(0.6 * glowAnimation.value),
                      blurRadius: 15 * glowAnimation.value,
                      spreadRadius: 3 * glowAnimation.value,
                    ),
                  ] : [],
                ),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 50,
                  color: index < rating 
                      ? const Color(0xFFffd700)
                      : (isDark ? Colors.white30 : const Color(0xFF1565C0).withOpacity(0.3)),
                ),
              ),
            ),
          );
        }),
      ),
      builder: (context, child) => child!,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final bool isEnabled;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isEnabled ? color : Colors.grey.shade600,
          width: 2,
        ),
        gradient: isEnabled ? LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ) : null,
      ),
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: isEnabled ? color : Colors.grey.shade600,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}
