import 'package:flutter/material.dart';
import '../profile.dart';
import '../../data/models/contact_message.dart';
import '../../data/services/api_service.dart';

class ContactInfo extends StatefulWidget {
  final Profile profile;

  const ContactInfo({super.key, required this.profile});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  Future<ContactMessage>? _sendMessageFuture;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      final message = ContactMessage(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        message: _messageController.text.trim(),
      );
      
      setState(() {
        _sendMessageFuture = ApiService.sendContactMessage(message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Text(
          'Get In Touch',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 12),
        const _ContactDivider(),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFF90CAF9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF4ecdc4).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactItem(
                      Icons.email,
                      widget.profile.email,
                      const Color(0xFF00d4ff),
                    ),
                    const SizedBox(height: 24),
                    _buildContactItem(
                      Icons.phone,
                      widget.profile.phone,
                      const Color(0xFF4ecdc4),
                    ),
                    const SizedBox(height: 24),
                    _buildContactItem(
                      Icons.location_on,
                      widget.profile.location,
                      const Color(0xFF45b7d1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField('Your Name', _nameController, 'Please enter your name'),
                      const SizedBox(height: 20),
                      _buildTextField('Your Email', _emailController, 'Please enter a valid email', isEmail: true),
                      const SizedBox(height: 20),
                      _buildTextField('Your Message', _messageController, 'Please enter your message', maxLines: 5),
                      const SizedBox(height: 30),
                      _sendMessageFuture == null
                          ? _SendButton(onPressed: _sendMessage)
                          : _MessageStatusBuilder(future: _sendMessageFuture!, onReset: () {
                              setState(() {
                                _sendMessageFuture = null;
                                _nameController.clear();
                                _emailController.clear();
                                _messageController.clear();
                              });
                            }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : const Color(0xFF0D47A1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, String errorMessage, {int maxLines = 1, bool isEmail = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a4a) : const Color(0xFF64B5F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00d4ff).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0D47A1),
          fontSize: 14,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return errorMessage;
          }
          if (isEmail && !_isValidEmail(value.trim())) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : const Color(0xFF1565C0).withOpacity(0.7),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          errorStyle: const TextStyle(
            color: Color(0xFFff6b6b),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ContactDivider extends StatelessWidget {
  const _ContactDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFF4ecdc4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SendButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00d4ff), Color(0xFF4ecdc4)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Send Message',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MessageStatusBuilder extends StatelessWidget {
  final Future<ContactMessage> future;
  final VoidCallback onReset;

  const _MessageStatusBuilder({required this.future, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ContactMessage>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingState();
        }
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error.toString(), onRetry: onReset);
        }
        if (snapshot.hasData) {
          return _SuccessState(onReset: onReset);
        }
        return const SizedBox();
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Sending...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.red, width: 1),
          ),
          child: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 24),
              const SizedBox(height: 8),
              Text(
                'Error: $error',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _ActionButton(label: 'Try Again', onPressed: onRetry),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;

  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(height: 8),
              Text(
                'Message sent successfully!',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _ActionButton(label: 'Send Another Message', onPressed: onReset),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00d4ff), Color(0xFF4ecdc4)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}