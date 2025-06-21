import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(
      {required String email, required String password});
  Future<AuthResponseModel> signup({
    required String fullName,
    required String birthday,
    required String phoneNumber,
    required String email,
    required String password,
  });
  // Add later methods for Google/Facebook OAuth if they involve direct client-side calls
}