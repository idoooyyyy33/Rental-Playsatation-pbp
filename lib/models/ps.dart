import 'base_model.dart';

class PS extends BaseModel {
  final String name;
  final int pricePerHour;

  PS({required this.name, required this.pricePerHour});

  @override
  List<Object?> get props => [name, pricePerHour];

  @override
  String getSummary() {
    return '$name - Rp $pricePerHour per hour';
  }

  @override
  String toString() {
    return 'PS(name: $name, pricePerHour: $pricePerHour)';
  }

  PS copyWith({
    String? name,
    int? pricePerHour,
  }) {
    return PS(
      name: name ?? this.name,
      pricePerHour: pricePerHour ?? this.pricePerHour,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pricePerHour': pricePerHour,
    };
  }

  factory PS.fromJson(Map<String, dynamic> json) {
    return PS(
      name: json['name'],
      pricePerHour: json['pricePerHour'],
    );
  }
}
