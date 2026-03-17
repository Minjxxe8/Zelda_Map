import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../model/user_model.dart';
import '../repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _authRepo = AuthRepository();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<String?> handleLogin(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _authRepo.login(email, password);

      _user = UserModel(
        id: res.user!.id,
        email: res.user!.email!,
        username: res.user!.userMetadata?['username'] ?? 'Inconnu',
      );
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> handleSignUp(
    String email,
    String password,
    String username,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _authRepo.signUp(email, password, username);

      _user = UserModel(
        id: res.user!.id,
        email: res.user!.email!,
        username: res.user!.userMetadata?['username'] ?? 'Inconnu',
      );
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleSignOut() async {
    await _authRepo.signOut();
    _user = null;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});
