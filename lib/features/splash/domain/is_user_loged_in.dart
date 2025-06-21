import 'package:dartz/dartz.dart';

import 'package:soccer_complex/features/auth/domain/repositories/auth_repository.dart';

import '../../../core/errors/failure.dart';
import '../../../core/usecase/usecase.dart';

class IsUserLoggedIn implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  IsUserLoggedIn(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final result = await repository.getToken();
    return result.fold(
      (failure) => const Right(false), // If there's a failure getting token, assume not logged in
      (token) => Right(token != null && token.isNotEmpty),
    );
  }
}