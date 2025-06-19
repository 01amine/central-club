import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  bool _isLoggedIn = false;

  @override
  Future<bool> isLoggedIn() async {
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _isLoggedIn;
  }

  @override
  Future<bool> login(String email, String password) async {

    await Future.delayed(const Duration(seconds: 2));
    if (email == 'user@example.com' && password == 'password') {
      _isLoggedIn = true;
      return true;
    }
    _isLoggedIn = false;
    return false;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    print('User logged out.');
  }
}