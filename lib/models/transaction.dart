import 'base_model.dart';
import 'food_order.dart';

class Transaction extends BaseModel {
  final String psName;
  final int pricePerHour;
  final DateTime startTime;
  final DateTime? endTime;
  final double? total;
  final int? paketJam;

  // New fields for food integration
  final List<FoodOrder> foodOrders;
  final int foodTotal;
  final double combinedTotal; // rental + food total

  Transaction({
    required this.psName,
    required this.pricePerHour,
    required this.startTime,
    this.endTime,
    this.total,
    this.paketJam,
    this.foodOrders = const [],
    this.foodTotal = 0,
    this.combinedTotal = 0,
  });

  @override
  List<Object?> get props => [psName, pricePerHour, startTime, endTime, total, paketJam, foodOrders, foodTotal, combinedTotal];

  @override
  String getSummary() {
    if (foodOrders.isNotEmpty) {
      return 'Transaction for $psName: Rp $combinedTotal (Rental: Rp $total + Food: Rp $foodTotal)';
    }
    return 'Transaction for $psName: Rp $total (${paketJam != null ? 'Paket $paketJam jam' : 'Open Timer'})';
  }

  @override
  String toString() {
    return 'Transaction(psName: $psName, pricePerHour: $pricePerHour, startTime: $startTime, endTime: $endTime, total: $total, paketJam: $paketJam, foodOrders: ${foodOrders.length} items, foodTotal: $foodTotal, combinedTotal: $combinedTotal)';
  }

  // Helper methods for food integration
  bool get hasFoodOrders => foodOrders.isNotEmpty;
  int get rentalOnlyTotal => (total ?? 0).toInt();
  int get totalWithFood => combinedTotal > 0 ? combinedTotal.toInt() : (rentalOnlyTotal + foodTotal);

  Transaction copyWith({
    String? psName,
    int? pricePerHour,
    DateTime? startTime,
    DateTime? endTime,
    double? total,
    int? paketJam,
    List<FoodOrder>? foodOrders,
    int? foodTotal,
    double? combinedTotal,
  }) {
    return Transaction(
      psName: psName ?? this.psName,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      total: total ?? this.total,
      paketJam: paketJam ?? this.paketJam,
      foodOrders: foodOrders ?? this.foodOrders,
      foodTotal: foodTotal ?? this.foodTotal,
      combinedTotal: combinedTotal ?? this.combinedTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'psName': psName,
      'pricePerHour': pricePerHour,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'total': total?.toDouble() ?? 0.0,
      'paketJam': paketJam,
      'foodOrders': foodOrders.map((order) => order.toJson()).toList(),
      'foodTotal': foodTotal,
      'combinedTotal': combinedTotal,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      psName: json['psName'],
      pricePerHour: json['pricePerHour'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      total: (json['total'] as num?)?.toDouble(),
      paketJam: json['paketJam'] is int ? json['paketJam'] : null,
      foodOrders: json['foodOrders'] != null
          ? (json['foodOrders'] as List).map((order) => FoodOrder.fromJson(order)).toList()
          : [],
      foodTotal: json['foodTotal'] ?? 0,
      combinedTotal: (json['combinedTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
