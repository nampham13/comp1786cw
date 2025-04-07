import 'yoga_class.dart';

class Booking {
  final String id;
  final String userEmail;
  final List<YogaClass> classes;
  final DateTime bookingDate;
  final double totalAmount;

  Booking({
    required this.id,
    required this.userEmail,
    required this.classes,
    required this.bookingDate,
    required this.totalAmount,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userEmail: json['userEmail'],
      classes: (json['classes'] as List)
          .map((classJson) => YogaClass.fromJson(classJson))
          .toList(),
      bookingDate: DateTime.parse(json['bookingDate']),
      totalAmount: json['totalAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'classes': classes.map((yogaClass) => yogaClass.toJson()).toList(),
      'bookingDate': bookingDate.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }
}