import 'available_date.dart';

class FieldSchedule {
  final String fieldId;
  final String fieldName;
  final String fieldType;
  final String location; 
  final List<AvailableDate> availableDates;

  const FieldSchedule({
    required this.fieldId,
    required this.fieldName,
    required this.fieldType,
    required this.location,
    required this.availableDates,
  });
}