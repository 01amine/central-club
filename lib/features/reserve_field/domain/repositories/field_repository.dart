import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/field_schedule.dart';
import '../entities/reservation.dart';
import '../entities/reservation_request.dart';

abstract class FieldRepository {
  Future<Either<Failure, List<FieldSchedule>>> getFieldSchedules(String fieldType);
  Future<Either<Failure, Reservation>> makeReservation(ReservationRequest request);
  Future<Either<Failure, List<Reservation>>> getUserReservations();
  Future<Either<Failure, bool>> cancelReservation(String reservationId);
}