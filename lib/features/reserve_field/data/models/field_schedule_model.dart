import '../../domain/entities/field_schedule.dart';
import 'available_date_model.dart';

class FieldScheduleModel extends FieldSchedule {
  const FieldScheduleModel({
    required super.fieldId,
    required super.fieldName,
    required super.fieldType,
    required super.location,
    required super.availableDates,
  });

  factory FieldScheduleModel.fromJson(Map<String, dynamic> json) {
    return FieldScheduleModel(
      fieldId: json['field_id'] ?? '',
      fieldName: json['field_name'] ?? '',
      fieldType: json['field_type'] ?? '',
      location: json['location'] ?? '',
      availableDates: (json['available_dates'] as List<dynamic>?)
          ?.map((date) => AvailableDateModel.fromJson(date))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_id': fieldId,
      'field_name': fieldName,
      'field_type': fieldType,
      'location': location,
      'available_dates': availableDates
          .map((date) => (date as AvailableDateModel).toJson())
          .toList(),
    };
  }
}