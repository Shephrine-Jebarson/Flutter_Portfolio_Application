class ContactMessage {
  final String name;
  final String email;
  final String message;
  final int? id;

  ContactMessage({
    required this.name,
    required this.email,
    required this.message,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'body': message,
      'userId': 1,
    };
  }

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? '',
      email: json['email'] ?? '',
      message: json['body'] ?? '',
    );
  }
}