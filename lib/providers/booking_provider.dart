import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../models/cart_item.dart';
import '../models/class_instance.dart';
import '../models/yoga_class.dart';
import '../services/firebase_service.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  
  List<CartItem> _cart = [];
  List<Booking> _userBookings = [];
  String? _userEmail;
  
  BookingProvider(this._firebaseService);
  
  List<CartItem> get cart => _cart;
  List<Booking> get userBookings => _userBookings;
  String? get userEmail => _userEmail;
  
  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.price);
  
  void setUserEmail(String email) {
    _userEmail = email;
    fetchUserBookings();
    notifyListeners();
  }
  
  void addToCart(CartItem item) {
    // Check if class is already in cart
    bool exists = _cart.any((cartItem) => cartItem.classInstance.id == item.classInstance.id);
    
    if (!exists) {
      _cart.add(item);
      notifyListeners();
    }
  }
  
  void removeFromCart(String classInstanceId) {
    _cart.removeWhere((item) => item.classInstance.id == classInstanceId);
    notifyListeners();
  }
  
  void clearCart() {
    _cart = [];
    notifyListeners();
  }
  
  Future<bool> checkout() async {
    if (_userEmail == null || _cart.isEmpty) {
      return false;
    }
    
    try {
      // Create booking
      Booking booking = Booking(
        id: '', // Will be set by Firestore
        userEmail: _userEmail!,
        classIds: _cart.map((item) => item.classInstance.id).toList(),
        bookingDate: DateTime.now(),
        totalAmount: cartTotal,
      );
      
      String bookingId = await _firebaseService.createBooking(booking);
      
      // Clear cart after successful booking
      clearCart();
      
      // Refresh user bookings
      fetchUserBookings();
      
      return true;
    } catch (e) {
      print('Error during checkout: $e');
      return false;
    }
  }
  
  void fetchUserBookings() {
    if (_userEmail != null) {
      _firebaseService.getBookingsForUser(_userEmail!).listen((bookings) {
        _userBookings = bookings;
        notifyListeners();
      });
    }
  }
  
  Future<List<ClassInstance>> getBookedClassInstances(Booking booking) async {
    return await _firebaseService.getClassInstancesByIds(booking.classIds);
  }
  
  Future<YogaClass?> getYogaClassForInstance(ClassInstance instance) async {
    return await _firebaseService.getYogaClassById(instance.courseId);
  }
}