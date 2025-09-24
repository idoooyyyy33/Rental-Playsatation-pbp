import 'package:flutter/material.dart';
import 'base_model.dart';
import 'food_item.dart';

enum OrderStatus { pending, cooking, ready, served, cancelled }

class FoodOrderItem {
  final FoodItem foodItem;
  final int quantity;
  final String? notes;

  FoodOrderItem({
    required this.foodItem,
    required this.quantity,
    this.notes,
  });

  double get total => foodItem.price * quantity;

  String get formattedTotal => 'Rp ${total.toStringAsFixed(0)}';

  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'notes': notes,
      'total': total,
    };
  }

  factory FoodOrderItem.fromJson(Map<String, dynamic> json) {
    return FoodOrderItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'],
      notes: json['notes'],
    );
  }
}

class FoodOrder extends BaseModel {
  final String _id;
  final List<FoodOrderItem> _items;
  final double _total;
  final OrderStatus _status;
  final DateTime _orderTime;
  final String? _customerName;
  final String? _tableNumber;
  final String? _notes;
  final DateTime? _readyTime;
  final DateTime? _servedTime;

  FoodOrder({
    required String id,
    required List<FoodOrderItem> items,
    required double total,
    OrderStatus status = OrderStatus.pending,
    DateTime? orderTime,
    String? customerName,
    String? tableNumber,
    String? notes,
    DateTime? readyTime,
    DateTime? servedTime,
  })  : _id = id,
        _items = items,
        _total = total,
        _status = status,
        _orderTime = orderTime ?? DateTime.now(),
        _customerName = customerName,
        _tableNumber = tableNumber,
        _notes = notes,
        _readyTime = readyTime,
        _servedTime = servedTime;

  // Encapsulation: getters
  String get id => _id;
  List<FoodOrderItem> get items => List.unmodifiable(_items);
  double get total => _total;
  OrderStatus get status => _status;
  DateTime get orderTime => _orderTime;
  String? get customerName => _customerName;
  String? get tableNumber => _tableNumber;
  String? get notes => _notes;
  DateTime? get readyTime => _readyTime;
  DateTime? get servedTime => _servedTime;

  String get formattedTotal => 'Rp ${total.toStringAsFixed(0)}';

  String get statusText {
    switch (_status) {
      case OrderStatus.pending:
        return 'Menunggu';
      case OrderStatus.cooking:
        return 'Sedang Dibuat';
      case OrderStatus.ready:
        return 'Siap Saji';
      case OrderStatus.served:
        return 'Sudah Disajikan';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color get statusColor {
    switch (_status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.cooking:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.served:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  int get estimatedWaitTime {
    if (_status == OrderStatus.pending) {
      return _items.fold(0, (sum, item) => sum + item.foodItem.preparationTime);
    }
    return 0;
  }

  @override
  String getSummary() {
    return 'Order $_id - ${items.length} item(s) - $_total ($statusText)';
  }

  @override
  List<Object?> get props => [_id, _items, _total, _status, _orderTime, _customerName, _tableNumber];

  FoodOrder copyWith({
    String? id,
    List<FoodOrderItem>? items,
    double? total,
    OrderStatus? status,
    DateTime? orderTime,
    String? customerName,
    String? tableNumber,
    String? notes,
    DateTime? readyTime,
    DateTime? servedTime,
  }) {
    return FoodOrder(
      id: id ?? _id,
      items: items ?? _items,
      total: total ?? _total,
      status: status ?? _status,
      orderTime: orderTime ?? _orderTime,
      customerName: customerName ?? _customerName,
      tableNumber: tableNumber ?? _tableNumber,
      notes: notes ?? _notes,
      readyTime: readyTime ?? _readyTime,
      servedTime: servedTime ?? _servedTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'items': _items.map((item) => item.toJson()).toList(),
      'total': _total,
      'status': _status.index,
      'orderTime': _orderTime.toIso8601String(),
      'customerName': _customerName,
      'tableNumber': _tableNumber,
      'notes': _notes,
      'readyTime': _readyTime?.toIso8601String(),
      'servedTime': _servedTime?.toIso8601String(),
    };
  }

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'],
      items: (json['items'] as List).map((item) => FoodOrderItem.fromJson(item)).toList(),
      total: json['total'],
      status: OrderStatus.values[json['status']],
      orderTime: DateTime.parse(json['orderTime']),
      customerName: json['customerName'],
      tableNumber: json['tableNumber'],
      notes: json['notes'],
      readyTime: json['readyTime'] != null ? DateTime.parse(json['readyTime']) : null,
      servedTime: json['servedTime'] != null ? DateTime.parse(json['servedTime']) : null,
    );
  }
}
