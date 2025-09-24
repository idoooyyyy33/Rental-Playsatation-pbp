import 'package:flutter/material.dart';
import 'food_item.dart';

class FoodCartItem {
  final FoodItem foodItem;
  int quantity;
  final String? notes;

  FoodCartItem({
    required this.foodItem,
    this.quantity = 1,
    this.notes,
  });

  double get total => foodItem.price * quantity;

  String get formattedTotal => 'Rp ${total.toStringAsFixed(0)}';

  void increment() => quantity++;
  void decrement() => quantity = quantity > 1 ? quantity - 1 : 1;

  FoodCartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
    String? notes,
  }) {
    return FoodCartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'notes': notes,
      'total': total,
    };
  }

  factory FoodCartItem.fromJson(Map<String, dynamic> json) {
    return FoodCartItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'],
      notes: json['notes'],
    );
  }
}

class FoodCart extends ChangeNotifier {
  final List<FoodCartItem> _items = [];
  String? _customerName;
  String? _tableNumber;
  String? _notes;

  // Getters
  List<FoodCartItem> get items => List.unmodifiable(_items);
  String? get customerName => _customerName;
  String? get tableNumber => _tableNumber;
  String? get notes => _notes;

  // Computed properties
  int get itemCount => _items.length;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.total);
  String get formattedTotal => 'Rp ${totalAmount.toStringAsFixed(0)}';
  bool get isEmpty => _items.isEmpty;

  // Cart icon badge count
  int get cartBadgeCount => totalQuantity;

  // Methods
  void addItem(FoodItem foodItem, {int quantity = 1, String? notes}) {
    final existingIndex = _items.indexWhere((item) => item.foodItem.name == foodItem.name);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(FoodCartItem(
        foodItem: foodItem,
        quantity: quantity,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  void removeItem(FoodItem foodItem) {
    _items.removeWhere((item) => item.foodItem.name == foodItem.name);
    notifyListeners();
  }

  void updateQuantity(FoodItem foodItem, int newQuantity) {
    final index = _items.indexWhere((item) => item.foodItem.name == foodItem.name);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(FoodItem foodItem) {
    final index = _items.indexWhere((item) => item.foodItem.name == foodItem.name);
    if (index >= 0) {
      _items[index].increment();
      notifyListeners();
    }
  }

  void decrementQuantity(FoodItem foodItem) {
    final index = _items.indexWhere((item) => item.foodItem.name == foodItem.name);
    if (index >= 0) {
      _items[index].decrement();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _customerName = null;
    _tableNumber = null;
    _notes = null;
    notifyListeners();
  }

  void setCustomerInfo({
    String? customerName,
    String? tableNumber,
    String? notes,
  }) {
    _customerName = customerName;
    _tableNumber = tableNumber;
    _notes = notes;
    notifyListeners();
  }

  // Get items by category for organized display
  Map<String, List<FoodCartItem>> get itemsByCategory {
    final Map<String, List<FoodCartItem>> categorized = {};

    for (var item in _items) {
      final category = item.foodItem.categoryName;
      if (categorized[category] == null) {
        categorized[category] = [];
      }
      categorized[category]!.add(item);
    }

    return categorized;
  }

  // Get popular items (items with highest quantity)
  List<FoodCartItem> get popularItems {
    return List.from(_items)..sort((a, b) => b.quantity.compareTo(a.quantity));
  }

  // Check if specific food item exists in cart
  bool containsItem(FoodItem foodItem) {
    return _items.any((item) => item.foodItem.name == foodItem.name);
  }

  // Get quantity of specific item
  int getItemQuantity(FoodItem foodItem) {
    final item = _items.firstWhere(
      (item) => item.foodItem.name == foodItem.name,
      orElse: () => FoodCartItem(foodItem: foodItem, quantity: 0),
    );
    return item.quantity;
  }

  // Convert cart to order
  Map<String, dynamic> toOrderData() {
    return {
      'items': _items.map((item) => item.toJson()).toList(),
      'total': totalAmount,
      'customerName': _customerName,
      'tableNumber': _tableNumber,
      'notes': _notes,
      'itemCount': itemCount,
      'totalQuantity': totalQuantity,
    };
  }

  // Create summary text for display
  String get cartSummary {
    if (isEmpty) return 'Keranjang kosong';

    final itemText = totalQuantity == 1
        ? '1 item'
        : '$totalQuantity items';
    return '$itemText - $formattedTotal';
  }

  // Get estimated preparation time
  int get estimatedPreparationTime {
    if (isEmpty) return 0;
    return _items.fold(0, (sum, item) => sum + (item.foodItem.preparationTime * item.quantity));
  }

  String get estimatedTimeText {
    final minutes = estimatedPreparationTime;
    if (minutes < 60) {
      return '$minutes menit';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}j ${remainingMinutes}m';
    }
  }
}
