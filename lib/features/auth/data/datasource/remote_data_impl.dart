import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import 'remote_data.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl; 

  AuthRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'), 
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: json.decode(response.body)['message'] ?? 'Failed to log in');
    }
  }

  @override
  Future<AuthResponseModel> signup({
    required String fullName,
    required String birthday,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/signup'), 
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fullName': fullName,
        'birthday': birthday,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) { 
      return AuthResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: json.decode(response.body)['message'] ?? 'Failed to sign up');
    }
  }
}