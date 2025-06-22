import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/reservation.dart';
import '../repositories/field_repository.dart';

class GetUserReservations implements UseCase<List<Reservation>, NoParams> {
  final FieldRepository repository;

  GetUserReservations(this.repository);

  @override
  Future<Either<Failure, List<Reservation>>> call(NoParams params) async {
    return await repository.getUserReservations();
  }
}