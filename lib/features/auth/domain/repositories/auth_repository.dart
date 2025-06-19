// lib/src/features/authentication/domain/repositories/auth_repository.dart

abstract class AuthRepository {
  
  Future<bool> isLoggedIn();
  Future<bool> login(String email, String password);
  Future<void> logout();
}