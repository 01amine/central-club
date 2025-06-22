import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/auth_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login(
      {required String email, required String password});
  Future<Either<Failure, AuthResponse>> signup({
    required String fullName,
    required String birthday,
    required String phoneNumber,
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> saveToken(String token);
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, void>> clearToken();
}