import 'class_instance.dart';
import '../models/yoga_class.dart';

class CartItem {
  final ClassInstance classInstance;
  final YogaClass yogaClass;

  CartItem({
    required this.classInstance,
    required this.yogaClass,
  });

  double get price => yogaClass.price;
}