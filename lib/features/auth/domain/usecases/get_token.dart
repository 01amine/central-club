import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetToken implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetToken(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await repository.getToken();
  }
}