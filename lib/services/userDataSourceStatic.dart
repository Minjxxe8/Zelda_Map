import '/model/user.dart';
import '/services/userDataSource.dart';

class UserDataSourceStatic extends UserDataSource {
  UserDataSourceStatic(super.client);

  List<UserDto> mockUsers = [
    UserDto(id: 1, name: "name", email: "email"),
    UserDto(id: 2, name: "name2", email: "email2"),
    UserDto(id: 3, name: "name3", email: "email3"),
  ];

  @override
  Future<List<UserDto>> fetchUsers() {
    return Future(() {
      return mockUsers;
    });
  }

  @override
  Future<UserDto> fetchUser(String id) {
    return Future(() {
      return mockUsers.firstWhere((user) => user.id.toString() == id);
    });
  }
}
