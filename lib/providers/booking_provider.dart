import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/booking.dart';
import '../models/yoga_class.dart';
import '../services/api_service.dart';

class BookingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // In-memory storage of bookings by email
  final Map<String, List<Booking>> _bookingsByEmail = {};

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Booking> get bookings => [..._bookings];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch user bookings (from in-memory storage or API)
  Future<void> fetchUserBookings(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if we have bookings for this email in memory
      if (_bookingsByEmail.containsKey(email)) {
        _bookings = _bookingsByEmail[email]!;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Otherwise fetch from API
      try {
        final fetchedBookings = await _apiService.fetchUserBookings(email);
        _bookings = fetchedBookings;
        _bookingsByEmail[email] = fetchedBookings;
      } catch (apiError) {
        // If API fails, return empty list (for demo purposes)
        _bookings = [];
        _bookingsByEmail[email] = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit a new booking
  Future<bool> submitBooking(String email, List<YogaClass> classes) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to submit to API
      Booking newBooking;
      try {
        newBooking = await _apiService.submitBooking(email, classes);
      } catch (apiError) {
        // If API fails, create a mock booking (for demo purposes)
        final totalAmount = classes.fold(0.0, (sum, yogaClass) => sum + yogaClass.price);
        newBooking = Booking(
          id: 'local-${Random().nextInt(10000)}',
          userEmail: email,
          classes: List.from(classes),
          bookingDate: DateTime.now(),
          totalAmount: totalAmount,
        );
      }

      // Store in our in-memory storage
      if (!_bookingsByEmail.containsKey(email)) {
        _bookingsByEmail[email] = [];
      }
      _bookingsByEmail[email]!.add(newBooking);

      // Update current bookings if we're viewing this email's bookings
      if (_bookings.isNotEmpty && _bookings.first.userEmail == email) {
        _bookings.add(newBooking);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}