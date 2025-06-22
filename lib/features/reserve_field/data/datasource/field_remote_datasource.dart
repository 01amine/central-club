import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/field_schedule_model.dart';
import '../models/reservation_model.dart';
import '../models/reservation_request_model.dart';

abstract class FieldRemoteDataSource {
  Future<List<FieldScheduleModel>> getFieldSchedules(String fieldType);
  Future<ReservationModel> makeReservation(ReservationRequestModel request);
  Future<List<ReservationModel>> getUserReservations();
  Future<bool> cancelReservation(String reservationId);
}

class FieldRemoteDataSourceImpl implements FieldRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  FieldRemoteDataSourceImpl({
    required this.client,
    String? baseUrl,
  }) : baseUrl = baseUrl ?? EndPoints.baseUrl;

  @override
  Future<List<FieldScheduleModel>> getFieldSchedules(String fieldType) async {
    try {
      final uri = Uri.parse('$baseUrl/fields/schedules').replace(
        queryParameters: {'field_type': fieldType},
      );

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((json) => FieldScheduleModel.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          message: errorData['message'] ?? 'Failed to fetch field schedules',
        );
      }
    } on http.ClientException catch (e) {
      throw ServerException(
        message: 'Network error: ${e.message}',
      );
    } on FormatException catch (e) {
      throw ServerException(
        message: 'Invalid response format: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  @override
  Future<ReservationModel> makeReservation(
      ReservationRequestModel request) async {
    try {
      final uri = Uri.parse('$baseUrl/reservations');

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ReservationModel.fromJson(jsonData['data']);
      } else {
        final errorData = json.decode(response.body);

        if (response.statusCode == 409) {
          throw ServerException(
            message: 'This time slot is already reserved',
          );
        }

        throw ServerException(
          message: errorData['message'] ?? 'Failed to make reservation',
        );
      }
    } on http.ClientException catch (e) {
      throw ServerException(
        message: 'Network error: ${e.message}',
      );
    } on FormatException catch (e) {
      throw ServerException(
        message: 'Invalid response format: ${e.message}',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ReservationModel>> getUserReservations() async {
    try {
      final uri = Uri.parse('$baseUrl/reservations/user');

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((json) => ReservationModel.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          message: errorData['message'] ?? 'Failed to fetch reservations',
        );
      }
    } on http.ClientException catch (e) {
      throw ServerException(
        message: 'Network error: ${e.message}',
      );
    } on FormatException catch (e) {
      throw ServerException(
        message: 'Invalid response format: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> cancelReservation(String reservationId) async {
    try {
      final uri = Uri.parse('$baseUrl/reservations/$reservationId');

      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          message: errorData['message'] ?? 'Failed to cancel reservation',
        );
      }
    } on http.ClientException catch (e) {
      throw ServerException(
        message: 'Network error: ${e.message}',
      );
    } on FormatException catch (e) {
      throw ServerException(
        message: 'Invalid response format: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Future<String> getAuthToken() async {
  //   // Implement your token retrieval logic here
  //   return '';
  // }
}
