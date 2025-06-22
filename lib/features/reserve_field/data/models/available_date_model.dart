import '../../domain/entities/available_date.dart';
import 'available_time_slot_model.dart';

class AvailableDateModel extends AvailableDate {
  const AvailableDateModel({
    required super.date,
    required super.dayName,
    required super.day,
    required super.month,
    required super.availableTimeSlots,
  });

  factory AvailableDateModel.fromJson(Map<String, dynamic> json) {
    return AvailableDateModel(
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      day: json['day'] ?? '',
      month: json['month'] ?? '',
      availableTimeSlots: (json['available_time_slots'] as List<dynamic>?)
          ?.map((slot) => AvailableTimeSlotModel.fromJson(slot))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day_name': dayName,
      'day': day,
      'month': month,
      'available_time_slots': availableTimeSlots
          .map((slot) => (slot as AvailableTimeSlotModel).toJson())
          .toList(),
    };
  }
}