import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/reservation.dart';
import '../entities/reservation_request.dart';
import '../repositories/field_repository.dart';

class MakeReservation implements UseCase<Reservation, ReservationRequest> {
  final FieldRepository repository;

  MakeReservation(this.repository);

  @override
  Future<Either<Failure, Reservation>> call(ReservationRequest request) async {
    return await repository.makeReservation(request);
  }
}