import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/local_data.dart';
import '../datasource/remote_data.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse =
            await remoteDataSource.login(email: email, password: password);
        return Right(authResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signup({
    required String fullName,
    required String birthday,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await remoteDataSource.signup(
          fullName: fullName,
          birthday: birthday,
          phoneNumber: phoneNumber,
          email: email,
          password: password,
        );
        return Right(authResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await localDataSource.saveToken(token);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearToken() async {
    try {
      await localDataSource.clearToken();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}