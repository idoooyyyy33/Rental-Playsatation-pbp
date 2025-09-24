import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/food_item.dart';
import '../models/food_cart.dart';
import '../models/food_order.dart';

class FoodState extends ChangeNotifier {
  final FoodCart _foodCart = FoodCart();
  final List<FoodOrder> _foodOrders = [];

  FoodCart get foodCart => _foodCart;
  List<FoodOrder> get foodOrders => List.unmodifiable(_foodOrders);

  // Sample food menu items
  List<FoodItem> get foodMenu {
    return [
      // Snacks
      FoodItem(
        name: 'Kentang Goreng',
        price: 15000,
        category: FoodCategory.snacks,
        preparationTime: 10,
        description: 'Kentang goreng crispy dengan saus sambal',
      ),
      FoodItem(
        name: 'Nugget Ayam',
        price: 12000,
        category: FoodCategory.snacks,
        preparationTime: 8,
        description: 'Nugget ayam dengan saus tomat',
      ),
      FoodItem(
        name: 'Sosis Bakar',
        price: 10000,
        category: FoodCategory.snacks,
        preparationTime: 12,
        description: 'Sosis bakar dengan saus BBQ',
      ),

      // Drinks
      FoodItem(
        name: 'Es Teh Manis',
        price: 5000,
        category: FoodCategory.drinks,
        preparationTime: 3,
        description: 'Es teh manis segar',
      ),
      FoodItem(
        name: 'Kopi Hitam',
        price: 8000,
        category: FoodCategory.drinks,
        preparationTime: 5,
        description: 'Kopi hitam tanpa gula',
      ),
      FoodItem(
        name: 'Jus Jeruk',
        price: 10000,
        category: FoodCategory.drinks,
        preparationTime: 4,
        description: 'Jus jeruk segar tanpa gula',
      ),

      // Meals
      FoodItem(
        name: 'Nasi Gudeg',
        price: 25000,
        category: FoodCategory.meals,
        preparationTime: 20,
        description: 'Nasi gudeg dengan ayam dan telur',
      ),
      FoodItem(
        name: 'Ayam Bakar',
        price: 20000,
        category: FoodCategory.meals,
        preparationTime: 25,
        description: 'Ayam bakar dengan nasi dan lalapan',
      ),
      FoodItem(
        name: 'Ikan Bakar',
        price: 22000,
        category: FoodCategory.meals,
        preparationTime: 30,
        description: 'Ikan bakar dengan nasi dan sambal',
      ),

      // Combo
      FoodItem(
        name: 'Paket Hemat 1',
        price: 35000,
        category: FoodCategory.combo,
        preparationTime: 25,
        description: 'Nasi + Ayam + Es Teh + Kentang Goreng',
      ),
      FoodItem(
        name: 'Paket Keluarga',
        price: 75000,
        category: FoodCategory.combo,
        preparationTime: 35,
        description: 'Nasi Gudeg + 2 Ayam Bakar + 2 Es Teh + 2 Kentang Goreng',
      ),
    ];
  }

  void addToCart(FoodItem item, {int quantity = 1, String? notes}) {
    _foodCart.addItem(item, quantity: quantity, notes: notes);
    notifyListeners();
  }

  void removeFromCart(FoodItem item) {
    _foodCart.removeItem(item);
    notifyListeners();
  }

  void updateCartItemQuantity(FoodItem item, int quantity) {
    _foodCart.updateQuantity(item, quantity);
    notifyListeners();
  }

  void clearCart() {
    _foodCart.clearCart();
    notifyListeners();
  }

  String generateOrderId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(9999);
    return 'ORD$timestamp${randomNum.toString().padLeft(4, '0')}';
  }

  void addFoodOrder(FoodOrder order) {
    _foodOrders.insert(0, order);
    _saveFoodOrders();
    notifyListeners();
  }

  Future<void> _saveFoodOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersString = jsonEncode(_foodOrders.map((order) => order.toJson()).toList());
    await prefs.setString('foodOrders', ordersString);
  }

  Future<void> _loadFoodOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersString = prefs.getString('foodOrders');
    if (ordersString != null) {
      final List<dynamic> decoded = jsonDecode(ordersString);
      _foodOrders.clear();
      _foodOrders.addAll(decoded.map((e) => FoodOrder.fromJson(e)));
    }
  }

  FoodState() {
    _loadFoodOrders();
  }
}

final foodState = FoodState();
