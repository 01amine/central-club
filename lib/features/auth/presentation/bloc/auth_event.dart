part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String fullName;
  final String birthday;
  final String phoneNumber;
  final String email;
  final String password;

  const SignupRequested({
    required this.fullName,
    required this.birthday,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [fullName, birthday, phoneNumber, email, password];
}