import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class SignupUser implements UseCase<AuthResponse, SignupParams> {
  final AuthRepository repository;

  SignupUser(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(SignupParams params) async {
    return await repository.signup(
      fullName: params.fullName,
      birthday: params.birthday,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
    );
  }
}

class SignupParams extends Equatable {
  final String fullName;
  final String birthday;
  final String phoneNumber;
  final String email;
  final String password;

  const SignupParams({
    required this.fullName,
    required this.birthday,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props =>
      [fullName, birthday, phoneNumber, email, password];
}