import '../../domain/entities/reservation.dart';

class ReservationModel extends Reservation {
  const ReservationModel({
    required super.reservationId,
    required super.fieldId,
    required super.fieldName,
    required super.fieldType,
    required super.date,
    required super.timeSlotId,
    required super.startTime,
    required super.endTime,
    required super.price,
    required super.status,
    required super.createdAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      reservationId: json['reservation_id'] ?? '',
      fieldId: json['field_id'] ?? '',
      fieldName: json['field_name'] ?? '',
      fieldType: json['field_type'] ?? '',
      date: json['date'] ?? '',
      timeSlotId: json['time_slot_id'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservation_id': reservationId,
      'field_id': fieldId,
      'field_name': fieldName,
      'field_type': fieldType,
      'date': date,
      'time_slot_id': timeSlotId,
      'start_time': startTime,
      'end_time': endTime,
      'price': price,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}