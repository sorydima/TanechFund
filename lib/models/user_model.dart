/// Модель пользователя приложения.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final DateTime? lastLogin;
  final List<String> permissions;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
    this.lastLogin,
    required this.permissions,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? role,
    DateTime? lastLogin,
    List<String>? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      lastLogin: lastLogin ?? this.lastLogin,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'lastLogin': lastLogin?.toIso8601String(),
      'permissions': permissions,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'user',
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'] as String)
          : null,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  static const UserModel empty = UserModel(
    id: '',
    name: '',
    email: '',
    role: 'guest',
    permissions: [],
  );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;
}
