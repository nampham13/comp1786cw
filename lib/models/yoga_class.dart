class YogaClass {
  final String id;
  final String name;
  final String type;
  final String description;
  final String dayOfWeek;
  final String time;
  final int capacity;
  final int duration;
  final double price;
  final List<String> classInstanceIds;
  final Map<String, dynamic> additionalFields;

  YogaClass({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.dayOfWeek,
    required this.time,
    required this.capacity,
    required this.duration,
    required this.price,
    required this.classInstanceIds,
    required this.additionalFields,
  });

  factory YogaClass.fromMap(Map<String, dynamic> map, String id) {
    return YogaClass(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      dayOfWeek: map['dayOfWeek'] ?? '',
      time: map['time'] ?? '',
      capacity: map['capacity'] ?? 0,
      duration: map['duration'] ?? 0,
      price: map['price'] ?? 0.0,
      classInstanceIds: List<String>.from(map['classInstanceIds'] ?? []),
      additionalFields: Map<String, dynamic>.from(map['additionalFields'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'capacity': capacity,
      'duration': duration,
      'price': price,
      'classInstanceIds': classInstanceIds,
      'additionalFields': additionalFields,
    };
  }
}