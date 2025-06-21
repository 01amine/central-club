import 'package:equatable/equatable.dart';
import 'package:soccer_complex/features/auth/domain/entities/user.dart';

class AuthResponse extends Equatable {
  final String token;
  final User user;

  const AuthResponse({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}