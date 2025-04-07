import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/yoga_class.dart';
import '../models/booking.dart';

class ApiService {
  // Base URL for the API - replace with your actual API endpoint
  static const String baseUrl = 'https://api.yogastudio.com/api';

  // Mock data for testing
  final List<YogaClass> _mockClasses = [
    YogaClass(
      id: '1',
      title: 'Morning Vinyasa Flow',
      description: 'Start your day with an energizing Vinyasa flow that will awaken your body and mind. This class focuses on linking breath with movement to create a dynamic and fluid practice.',
      instructor: 'Sarah Johnson',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
      duration: 60,
      capacity: 15,
      enrolled: 8,
      price: 20.0,
    ),
    YogaClass(
      id: '2',
      title: 'Gentle Hatha Yoga',
      description: 'A slow-paced class focusing on basic yoga postures and alignment. Perfect for beginners or those looking for a more relaxed practice.',
      instructor: 'Michael Chen',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
      duration: 75,
      capacity: 20,
      enrolled: 12,
      price: 18.0,
    ),
    YogaClass(
      id: '3',
      title: 'Power Yoga',
      description: 'A vigorous, fitness-based approach to vinyasa-style yoga. This class will challenge your strength and endurance while helping you build flexibility.',
      instructor: 'Jessica Miller',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 18)),
      duration: 60,
      capacity: 15,
      enrolled: 15, // Full class
      price: 22.0,
    ),
    YogaClass(
      id: '4',
      title: 'Yin Yoga',
      description: 'A slow-paced style of yoga with postures that are held for longer periods of time. This meditative approach to yoga helps stretch the connective tissue and improve flexibility.',
      instructor: 'David Wilson',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 10)),
      duration: 90,
      capacity: 18,
      enrolled: 5,
      price: 25.0,
    ),
    YogaClass(
      id: '5',
      title: 'Restorative Yoga',
      description: 'A relaxing practice that uses props to support the body in gentle poses. This class is perfect for stress relief and deep relaxation.',
      instructor: 'Emma Thompson',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 19)),
      duration: 75,
      capacity: 12,
      enrolled: 6,
      price: 20.0,
    ),
    YogaClass(
      id: '6',
      title: 'Ashtanga Primary Series',
      description: 'A traditional and dynamic sequence of postures linked by breath. This class follows the primary series as taught by K. Pattabhi Jois.',
      instructor: 'Robert Garcia',
      dateTime: DateTime.now().add(const Duration(days: 4, hours: 7)),
      duration: 90,
      capacity: 10,
      enrolled: 8,
      price: 24.0,
    ),
    YogaClass(
      id: '7',
      title: 'Prenatal Yoga',
      description: 'A gentle class designed specifically for expectant mothers. This practice helps prepare the body for childbirth and reduces common discomforts of pregnancy.',
      instructor: 'Lisa Anderson',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 11)),
      duration: 60,
      capacity: 8,
      enrolled: 4,
      price: 22.0,
    ),
    YogaClass(
      id: '8',
      title: 'Yoga for Seniors',
      description: 'A gentle class focusing on improving balance, flexibility, and overall well-being. Modifications are offered for all levels of mobility.',
      instructor: 'James Peterson',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 14)),
      duration: 60,
      capacity: 15,
      enrolled: 10,
      price: 15.0,
    ),
  ];

  // Fetch all yoga classes
  Future<List<YogaClass>> fetchYogaClasses() async {
    // For demo purposes, return mock data
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _mockClasses;

    // Real implementation would be:
    /*
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes'));

      if (response.statusCode == 200) {
        final List<dynamic> classesJson = json.decode(response.body);
        return classesJson.map((json) => YogaClass.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load yoga classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching yoga classes: $e');
    }
    */
  }

  // Fetch a specific yoga class by ID
  Future<YogaClass> fetchYogaClassById(String id) async {
    // For demo purposes, return mock data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    final yogaClass = _mockClasses.firstWhere(
      (yogaClass) => yogaClass.id == id,
      orElse: () => throw Exception('Yoga class not found'),
    );
    return yogaClass;

    // Real implementation would be:
    /*
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes/$id'));

      if (response.statusCode == 200) {
        return YogaClass.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load yoga class: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching yoga class: $e');
    }
    */
  }

  // Submit a booking
  Future<Booking> submitBooking(String email, List<YogaClass> classes) async {
    // For demo purposes, create a mock booking
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final totalAmount = classes.fold(0.0, (sum, yogaClass) => sum + yogaClass.price);

    return Booking(
      id: 'booking-${Random().nextInt(10000)}',
      userEmail: email,
      classes: classes,
      bookingDate: DateTime.now(),
      totalAmount: totalAmount,
    );

    // Real implementation would be:
    /*
    try {
      final totalAmount = classes.fold(0.0, (sum, yogaClass) => sum + yogaClass.price);

      final bookingData = {
        'userEmail': email,
        'classes': classes.map((yogaClass) => yogaClass.id).toList(),
        'bookingDate': DateTime.now().toIso8601String(),
        'totalAmount': totalAmount,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingData),
      );

      if (response.statusCode == 201) {
        return Booking.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting booking: $e');
    }
    */
  }

  // Fetch user bookings by email
  Future<List<Booking>> fetchUserBookings(String email) async {
    // For demo purposes, return empty list (bookings will be stored in memory)
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [];

    // Real implementation would be:
    /*
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings?userEmail=$email'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> bookingsJson = json.decode(response.body);
        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
    */
  }
}