import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/yoga_class.dart';

class CartProvider with ChangeNotifier {
  Cart _cart = Cart();
  
  Cart get cart => _cart;
  
  int get itemCount => _cart.itemCount;
  
  double get totalAmount => _cart.totalAmount;
  
  bool isInCart(YogaClass yogaClass) {
    return _cart.contains(yogaClass);
  }
  
  void addItem(YogaClass yogaClass) {
    _cart = _cart.addItem(yogaClass);
    notifyListeners();
  }
  
  void removeItem(String yogaClassId) {
    _cart = _cart.removeItem(yogaClassId);
    notifyListeners();
  }
  
  void clear() {
    _cart = _cart.clear();
    notifyListeners();
  }
}