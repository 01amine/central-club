import '../../auth/domain/repositories/auth_repository.dart';

class IsUserLoggedIn {
  final AuthRepository repository;

  IsUserLoggedIn(this.repository);

  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}