import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/field_schedule.dart';
import '../repositories/field_repository.dart';

class GetFieldSchedules implements UseCase<List<FieldSchedule>, String> {
  final FieldRepository repository;

  GetFieldSchedules(this.repository);

  @override
  Future<Either<Failure, List<FieldSchedule>>> call(String fieldType) async {
    return await repository.getFieldSchedules(fieldType);
  }
}