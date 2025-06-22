import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/field_schedule.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/entities/reservation_request.dart';
import '../../domain/repositories/field_repository.dart';
import '../datasource/field_local_datasource.dart';
import '../datasource/field_remote_datasource.dart';
import '../models/reservation_request_model.dart';

class FieldRepositoryImpl implements FieldRepository {
  final FieldRemoteDataSource remoteDataSource;
  final FieldLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FieldRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FieldSchedule>>> getFieldSchedules(
      String fieldType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSchedules =
            await remoteDataSource.getFieldSchedules(fieldType);
        await localDataSource.cacheFieldSchedules(fieldType, remoteSchedules);
        return Right(remoteSchedules);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: 'An unexpected error occurred',
        ));
      }
    } else {
      try {
        final localSchedules =
            await localDataSource.getCachedFieldSchedules(fieldType);
        return Right(localSchedules);
      } on CacheException {
        return Left(CacheFailure());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Reservation>> makeReservation(
      ReservationRequest request) async {
    if (await networkInfo.isConnected) {
      try {
        final requestModel = ReservationRequestModel(
          fieldId: request.fieldId,
          date: request.date,
          timeSlotId: request.timeSlotId,
        );

        final reservation =
            await remoteDataSource.makeReservation(requestModel);

        
        try {
          final cachedReservations =
              await localDataSource.getCachedUserReservations();
          cachedReservations.add(reservation);
          await localDataSource.cacheUserReservations(cachedReservations);
        } catch (e) {
          
        }

        return Right(reservation);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: 'An unexpected error occurred while making reservation',
        ));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Reservation>>> getUserReservations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReservations = await remoteDataSource.getUserReservations();
        await localDataSource.cacheUserReservations(remoteReservations);
        return Right(remoteReservations);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: 'An unexpected error occurred',
        ));
      }
    } else {
      try {
        final localReservations =
            await localDataSource.getCachedUserReservations();
        return Right(localReservations);
      } on CacheException {
        return Left(CacheFailure());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> cancelReservation(String reservationId) async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.cancelReservation(reservationId);

        if (success) {
          
          try {
            final cachedReservations =
                await localDataSource.getCachedUserReservations();
            final updatedReservations = cachedReservations
                .where(
                    (reservation) => reservation.reservationId != reservationId)
                .toList();
            await localDataSource.cacheUserReservations(updatedReservations);
          } catch (e) {
            
          }
        }

        return Right(success);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
        ));
      } catch (e) {
        return Left(ServerFailure(
          message: 'An unexpected error occurred while cancelling reservation',
        ));
      }
    } else {
      return Left(ServerFailure(
        message: 'No internet connection',
      ));
    }
  }
}
