class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final int version;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.version,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'No Email',
      role: json['role'] ?? 'user',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      '__v': version,
    };
  }
}
