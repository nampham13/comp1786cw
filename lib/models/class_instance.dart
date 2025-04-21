class ClassInstance {
  final String id;
  final String courseId;
  final DateTime date;
  final String teacherName;
  final String comments;
  final bool isCancelled;

  ClassInstance({
    required this.id,
    required this.courseId,
    required this.date,
    required this.teacherName,
    required this.comments,
    required this.isCancelled,
  });

  factory ClassInstance.fromMap(Map<String, dynamic> map, String id) {
    return ClassInstance(
      id: id,
      courseId: map['courseId'] ?? '',
      date: map['date']?.toDate() ?? DateTime.now(),
      teacherName: map['teacherName'] ?? '',
      comments: map['comments'] ?? '',
      isCancelled: map['isCancelled'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'date': date,
      'teacherName': teacherName,
      'comments': comments,
      'isCancelled': isCancelled,
    };
  }
}