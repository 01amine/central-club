import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime birthday;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.birthday,
  });

  @override
  List<Object> get props => [id, fullName, email, phoneNumber, birthday];
}