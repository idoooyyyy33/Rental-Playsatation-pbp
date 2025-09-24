import 'base_model.dart';

enum FoodCategory { snacks, drinks, meals, combo }

class FoodItem extends BaseModel {
  final String _name;
  final String _description;
  final double _price;
  final FoodCategory _category;
  final String? _imageUrl;
  final bool _isAvailable;
  final int _preparationTime; // in minutes

  FoodItem({
    required String name,
    required String description,
    required double price,
    required FoodCategory category,
    String? imageUrl,
    bool isAvailable = true,
    int preparationTime = 5,
  })  : _name = name,
        _description = description,
        _price = price,
        _category = category,
        _imageUrl = imageUrl,
        _isAvailable = isAvailable,
        _preparationTime = preparationTime;

  // Encapsulation: getters
  String get name => _name;
  String get description => _description;
  double get price => _price;
  FoodCategory get category => _category;
  String? get imageUrl => _imageUrl;
  bool get isAvailable => _isAvailable;
  int get preparationTime => _preparationTime;

  String get categoryName {
    switch (_category) {
      case FoodCategory.snacks:
        return 'Snacks';
      case FoodCategory.drinks:
        return 'Minuman';
      case FoodCategory.meals:
        return 'Makanan Berat';
      case FoodCategory.combo:
        return 'Paket Combo';
    }
  }

  String get formattedPrice => 'Rp ${price.toStringAsFixed(0)}';

  @override
  String getSummary() {
    return '$_name - ${_price.toStringAsFixed(0)} (${_preparationTime} menit)';
  }

  @override
  List<Object?> get props => [_name, _description, _price, _category, _imageUrl, _isAvailable, _preparationTime];

  FoodItem copyWith({
    String? name,
    String? description,
    double? price,
    FoodCategory? category,
    String? imageUrl,
    bool? isAvailable,
    int? preparationTime,
  }) {
    return FoodItem(
      name: name ?? _name,
      description: description ?? _description,
      price: price ?? _price,
      category: category ?? _category,
      imageUrl: imageUrl ?? _imageUrl,
      isAvailable: isAvailable ?? _isAvailable,
      preparationTime: preparationTime ?? _preparationTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'price': _price,
      'category': _category.index,
      'imageUrl': _imageUrl,
      'isAvailable': _isAvailable,
      'preparationTime': _preparationTime,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: FoodCategory.values[json['category']],
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'],
      preparationTime: json['preparationTime'],
    );
  }
}
