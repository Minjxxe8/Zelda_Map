class UserModel {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
  });

  // Pour plus tard : transformer le JSON de Supabase en objet Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
    );
  }
}