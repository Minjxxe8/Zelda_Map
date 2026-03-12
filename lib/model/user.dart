class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromDto(UserDto dto) {
    return User(id: dto.id, name: dto.name, email: dto.email);
  }
}

class UserDto {
  final int id;
  final String name;
  final String email;

  UserDto({required this.id, required this.name, required this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'name': String name, 'email': String email} => UserDto(
        id: id,
        name: name,
        email: email,
      ),
      _ => throw FormatException('Structure JSON invalide pour User'),
    };
  }
}
