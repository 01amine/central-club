import '../../domain/entities/reservation_request.dart';

class ReservationRequestModel extends ReservationRequest {
  const ReservationRequestModel({
    required super.fieldId,
    required super.date,
    required super.timeSlotId,
  });

  factory ReservationRequestModel.fromJson(Map<String, dynamic> json) {
    return ReservationRequestModel(
      fieldId: json['field_id'] ?? '',
      date: json['date'] ?? '',
      timeSlotId: json['time_slot_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_id': fieldId,
      'date': date,
      'time_slot_id': timeSlotId,
    };
  }
}