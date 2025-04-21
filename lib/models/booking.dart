class Booking {
  final String id;
  final String userEmail;
  final List<String> classIds;
  final DateTime bookingDate;
  final double totalAmount;

  Booking({
    required this.id,
    required this.userEmail,
    required this.classIds,
    required this.bookingDate,
    required this.totalAmount,
  });

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      userEmail: map['userEmail'] ?? '',
      classIds: List<String>.from(map['classIds'] ?? []),
      bookingDate: map['bookingDate']?.toDate() ?? DateTime.now(),
      totalAmount: map['totalAmount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'classIds': classIds,
      'bookingDate': bookingDate,
      'totalAmount': totalAmount,
    };
  }
}