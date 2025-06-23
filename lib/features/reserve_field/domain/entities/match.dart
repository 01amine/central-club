class OpenMatch {
  final String matchId;
  final String fieldType;
  final String fieldName;
  final String date;
  final String time;
  final String creatorName;
  final int totalSeats;
  final int availableSeats;
  final double pricePerSeat;
  final String location;

  const OpenMatch({
    required this.matchId,
    required this.fieldType,
    required this.fieldName,
    required this.date,
    required this.time,
    required this.creatorName,
    required this.totalSeats,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.location,
  });

  bool get isFull => availableSeats <= 0;
}