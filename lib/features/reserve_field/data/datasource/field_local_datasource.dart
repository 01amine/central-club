import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/field_schedule_model.dart';
import '../models/reservation_model.dart';

abstract class FieldLocalDataSource {
  Future<List<FieldScheduleModel>> getCachedFieldSchedules(String fieldType);
  Future<void> cacheFieldSchedules(
      String fieldType, List<FieldScheduleModel> schedules);
  Future<List<ReservationModel>> getCachedUserReservations();
  Future<void> cacheUserReservations(List<ReservationModel> reservations);
  Future<void> clearCache();
}

class FieldLocalDataSourceImpl implements FieldLocalDataSource {
  final SharedPreferences sharedPreferences;

  FieldLocalDataSourceImpl({required this.sharedPreferences});

  static const String _fieldSchedulesKey = 'CACHED_FIELD_SCHEDULES';
  static const String _userReservationsKey = 'CACHED_USER_RESERVATIONS';

  @override
  Future<List<FieldScheduleModel>> getCachedFieldSchedules(
      String fieldType) async {
    try {
      final jsonString =
          sharedPreferences.getString('${_fieldSchedulesKey}_$fieldType');
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((json) => FieldScheduleModel.fromJson(json))
            .toList();
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheFieldSchedules(
      String fieldType, List<FieldScheduleModel> schedules) async {
    try {
      final jsonString =
          json.encode(schedules.map((schedule) => schedule.toJson()).toList());
      await sharedPreferences.setString(
          '${_fieldSchedulesKey}_$fieldType', jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<ReservationModel>> getCachedUserReservations() async {
    try {
      final jsonString = sharedPreferences.getString(_userReservationsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => ReservationModel.fromJson(json)).toList();
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUserReservations(
      List<ReservationModel> reservations) async {
    try {
      final jsonString = json.encode(
          reservations.map((reservation) => reservation.toJson()).toList());
      await sharedPreferences.setString(_userReservationsKey, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_fieldSchedulesKey);
      await sharedPreferences.remove(_userReservationsKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
