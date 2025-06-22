import 'package:equatable/equatable.dart';
import '../../domain/entities/reservation_request.dart';

abstract class FieldReservationEvent extends Equatable {
  const FieldReservationEvent();

  @override
  List<Object?> get props => [];
}

class LoadFieldSchedules extends FieldReservationEvent {
  final String fieldType;

  const LoadFieldSchedules({required this.fieldType});

  @override
  List<Object?> get props => [fieldType];
}

class MakeFieldReservation extends FieldReservationEvent {
  final ReservationRequest request;

  const MakeFieldReservation({required this.request});

  @override
  List<Object?> get props => [request];
}

class LoadUserReservations extends FieldReservationEvent {
  const LoadUserReservations();
}

class CancelFieldReservation extends FieldReservationEvent {
  final String reservationId;

  const CancelFieldReservation({required this.reservationId});

  @override
  List<Object?> get props => [reservationId];
}

class ResetReservationState extends FieldReservationEvent {
  const ResetReservationState();
}