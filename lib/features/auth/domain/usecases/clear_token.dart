import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ClearToken implements UseCase<void, NoParams> {
  final AuthRepository repository;

  ClearToken(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearToken();
  }
}