class YogaClass {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final DateTime dateTime;
  final int duration; // in minutes
  final int capacity;
  final int enrolled;
  final double price;

  YogaClass({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.dateTime,
    required this.duration,
    required this.capacity,
    required this.enrolled,
    required this.price,
  });

  factory YogaClass.fromJson(Map<String, dynamic> json) {
    return YogaClass(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      dateTime: DateTime.parse(json['dateTime']),
      duration: json['duration'],
      capacity: json['capacity'],
      enrolled: json['enrolled'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'dateTime': dateTime.toIso8601String(),
      'duration': duration,
      'capacity': capacity,
      'enrolled': enrolled,
      'price': price,
    };
  }

  bool get isAvailable => enrolled < capacity;
  
  String get dayOfWeek {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dateTime.weekday - 1];
  }
  
  String get timeOfDay {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}