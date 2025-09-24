import 'base_model.dart';

class ShiftKeeper extends BaseModel {
  final String _name;
  final DateTime _startShift;
  final DateTime _endShift;
  final String _psAssigned;

  ShiftKeeper({
    required String name,
    required DateTime startShift,
    required DateTime endShift,
    required String psAssigned,
  })  : _name = name,
        _startShift = startShift,
        _endShift = endShift,
        _psAssigned = psAssigned;

  // Encapsulation: getters for private fields
  String get name => _name;
  DateTime get startShift => _startShift;
  DateTime get endShift => _endShift;
  String get psAssigned => _psAssigned;

  // Polymorphism: override getSummary
  @override
  String getSummary() {
    return 'Penjaga $_name bertugas di $_psAssigned dari ${startShift.hour}:${startShift.minute.toString().padLeft(2, '0')} sampai ${endShift.hour}:${endShift.minute.toString().padLeft(2, '0')}';
  }

  // Check if currently on shift (additional method for polymorphism)
  bool isOnShift(DateTime now) {
    return now.isAfter(_startShift) && now.isBefore(_endShift);
  }

  @override
  List<Object?> get props => [_name, _startShift, _endShift, _psAssigned];

  ShiftKeeper copyWith({
    String? name,
    DateTime? startShift,
    DateTime? endShift,
    String? psAssigned,
  }) {
    return ShiftKeeper(
      name: name ?? _name,
      startShift: startShift ?? _startShift,
      endShift: endShift ?? _endShift,
      psAssigned: psAssigned ?? _psAssigned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'startShift': _startShift.toIso8601String(),
      'endShift': _endShift.toIso8601String(),
      'psAssigned': _psAssigned,
    };
  }

  factory ShiftKeeper.fromJson(Map<String, dynamic> json) {
    return ShiftKeeper(
      name: json['name'],
      startShift: DateTime.parse(json['startShift']),
      endShift: DateTime.parse(json['endShift']),
      psAssigned: json['psAssigned'],
    );
  }
}
