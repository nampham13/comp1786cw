import 'yoga_class.dart';

class CartItem {
  final YogaClass yogaClass;
  final int quantity;

  CartItem({
    required this.yogaClass,
    this.quantity = 1,
  });

  double get totalPrice => yogaClass.price * quantity;
}

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return items.length;
  }

  bool contains(YogaClass yogaClass) {
    return items.any((item) => item.yogaClass.id == yogaClass.id);
  }

  Cart addItem(YogaClass yogaClass) {
    final existingIndex = items.indexWhere((item) => item.yogaClass.id == yogaClass.id);
    
    if (existingIndex >= 0) {
      // If the class is already in the cart, we don't add it again
      return this;
    }
    
    final newItems = List<CartItem>.from(items);
    newItems.add(CartItem(yogaClass: yogaClass));
    
    return Cart(items: newItems);
  }

  Cart removeItem(String yogaClassId) {
    final newItems = items.where((item) => item.yogaClass.id != yogaClassId).toList();
    return Cart(items: newItems);
  }

  Cart clear() {
    return Cart(items: []);
  }
}