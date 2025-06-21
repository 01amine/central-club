import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String fullName,
    required String email,
    required String phoneNumber,
    required DateTime birthday,
  }) : super(
          id: id,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          birthday: birthday,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      birthday: json['birthday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthday': birthday,
    };
  }
}