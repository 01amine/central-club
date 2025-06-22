import '../../domain/entities/available_time_slot.dart';

class AvailableTimeSlotModel extends AvailableTimeSlot {
  const AvailableTimeSlotModel({
    required super.timeSlotId,
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
    required super.price,
  });

  factory AvailableTimeSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableTimeSlotModel(
      timeSlotId: json['time_slot_id'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      isAvailable: json['is_available'] ?? false,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time_slot_id': timeSlotId,
      'start_time': startTime,
      'end_time': endTime,
      'is_available': isAvailable,
      'price': price,
    };
  }
}