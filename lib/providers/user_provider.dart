/*import '/model/user_model.dart';
import '/repository/user_repository.dart';
import '/services/userDataSourceStatic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final userDataSourceProvider = Provider((ref) {
  final client = http.Client();
  // return UserDataSource(client);
  return UserDataSourceStatic(client);
});

// Provider pour le repository (Service locator pattern)
final userRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepository(dataSource);
});

// Provider pour la liste de tous les utilisateurs
final allUsersProvider = FutureProvider<List<User>>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUsers();
});

// Provider paramétré (.family) pour un utilisateur spécifique
final userDetailProvider = FutureProvider.family<User, String>((ref, id) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUser(id);
});*/
