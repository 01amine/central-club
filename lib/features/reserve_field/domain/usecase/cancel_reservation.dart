import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/field_repository.dart';

class CancelReservation implements UseCase<bool, String> {
  final FieldRepository repository;

  CancelReservation(this.repository);

  @override
  Future<Either<Failure, bool>> call(String reservationId) async {
    return await repository.cancelReservation(reservationId);
  }
}