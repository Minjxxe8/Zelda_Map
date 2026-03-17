class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> signUp(String email, String password, String username) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}