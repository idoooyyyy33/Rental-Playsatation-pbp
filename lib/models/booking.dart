import 'base_model.dart';

class Booking extends BaseModel {
  final String psName;
  final DateTime dateTime;

  Booking({required this.psName, required this.dateTime});

  @override
  List<Object?> get props => [psName, dateTime];

  @override
  String getSummary() {
    return 'Booking for $psName at ${dateTime.toLocal()}';
  }

  @override
  String toString() {
    return 'Booking(psName: $psName, dateTime: $dateTime)';
  }

  Booking copyWith({
    String? psName,
    DateTime? dateTime,
  }) {
    return Booking(
      psName: psName ?? this.psName,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'psName': psName,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      psName: json['psName'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
