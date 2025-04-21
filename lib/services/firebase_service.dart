import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/yoga_class.dart';
import '../models/class_instance.dart';
import '../models/booking.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference _coursesCollection = 
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference _classInstancesCollection = 
      FirebaseFirestore.instance.collection('classInstances');
  final CollectionReference _bookingsCollection = 
      FirebaseFirestore.instance.collection('bookings');

  // Get all yoga classes
  Stream<List<YogaClass>> getYogaClasses() {
    return _coursesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return YogaClass.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get yoga class by ID
  Future<YogaClass?> getYogaClassById(String id) async {
    DocumentSnapshot doc = await _coursesCollection.doc(id).get();
    if (doc.exists) {
      return YogaClass.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Get class instances for a yoga class
  Stream<List<ClassInstance>> getClassInstancesForCourse(String courseId) {
    return _classInstancesCollection
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ClassInstance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get upcoming class instances for a yoga class
  Stream<List<ClassInstance>> getUpcomingClassInstancesForCourse(String courseId) {
    return _classInstancesCollection
        .where('courseId', isEqualTo: courseId)
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ClassInstance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get class instance by ID
  Future<ClassInstance?> getClassInstanceById(String id) async {
    DocumentSnapshot doc = await _classInstancesCollection.doc(id).get();
    if (doc.exists) {
      return ClassInstance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Create a booking
  Future<String> createBooking(Booking booking) async {
    DocumentReference docRef = await _bookingsCollection.add(booking.toMap());
    return docRef.id;
  }

  // Get bookings for a user
  Stream<List<Booking>> getBookingsForUser(String email) {
    return _bookingsCollection
        .where('userEmail', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Filter yoga classes by day of week
  Stream<List<YogaClass>> getYogaClassesByDay(String dayOfWeek) {
    return _coursesCollection
        .where('dayOfWeek', isEqualTo: dayOfWeek)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return YogaClass.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Filter yoga classes by time range
  Stream<List<YogaClass>> getYogaClassesByTimeRange(String startTime, String endTime) {
    return _coursesCollection
        .where('time', isGreaterThanOrEqualTo: startTime)
        .where('time', isLessThanOrEqualTo: endTime)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return YogaClass.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get class instances by IDs
  Future<List<ClassInstance>> getClassInstancesByIds(List<String> ids) async {
    List<ClassInstance> instances = [];
    
    for (String id in ids) {
      ClassInstance? instance = await getClassInstanceById(id);
      if (instance != null) {
        instances.add(instance);
      }
    }
    
    return instances;
  }
}