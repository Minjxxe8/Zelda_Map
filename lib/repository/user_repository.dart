import '/model/user_model.dart';
import '/services/auth_service.dart';
/*
class UserRepository {
  final UserDataSource dataSource;
  UserRepository(this.dataSource);

  Future<User> getUser(String id) async {
    final UserDto dto = await dataSource.fetchUser(id);

    return User.fromDto(dto);
  }

  Future<List<User>> getUsers() async {
    final List<UserDto> dtos = await dataSource.fetchUsers();

    final List<User> users = dtos.map((dto) => User.fromDto(dto)).toList();

    return users;
  }
}*/
