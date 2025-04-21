import 'package:flutter/foundation.dart';
import '../models/yoga_class.dart';
import '../models/class_instance.dart';
import '../services/firebase_service.dart';

class ClassProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  
  List<YogaClass> _classes = [];
  List<YogaClass> _filteredClasses = [];
  String? _selectedDay;
  String? _selectedTimeRange;
  
  ClassProvider(this._firebaseService) {
    fetchClasses();
  }
  
  List<YogaClass> get classes => _classes;
  List<YogaClass> get filteredClasses => _filteredClasses.isEmpty ? _classes : _filteredClasses;
  String? get selectedDay => _selectedDay;
  String? get selectedTimeRange => _selectedTimeRange;
  
  void fetchClasses() {
    _firebaseService.getYogaClasses().listen((classes) {
      _classes = classes;
      _applyFilters();
      notifyListeners();
    });
  }
  
  Future<YogaClass?> getClassById(String id) async {
    return await _firebaseService.getYogaClassById(id);
  }
  
  Stream<List<ClassInstance>> getClassInstancesForCourse(String courseId) {
    return _firebaseService.getClassInstancesForCourse(courseId);
  }
  
  Stream<List<ClassInstance>> getUpcomingClassInstancesForCourse(String courseId) {
    return _firebaseService.getUpcomingClassInstancesForCourse(courseId);
  }
  
  Future<ClassInstance?> getClassInstanceById(String id) async {
    return await _firebaseService.getClassInstanceById(id);
  }
  
  void filterByDay(String? day) {
    _selectedDay = day;
    _applyFilters();
    notifyListeners();
  }
  
  void filterByTimeRange(String? timeRange) {
    _selectedTimeRange = timeRange;
    _applyFilters();
    notifyListeners();
  }
  
  void clearFilters() {
    _selectedDay = null;
    _selectedTimeRange = null;
    _filteredClasses = [];
    notifyListeners();
  }
  
  void _applyFilters() {
    _filteredClasses = _classes;
    
    if (_selectedDay != null) {
      _filteredClasses = _filteredClasses.where((c) => c.dayOfWeek == _selectedDay).toList();
    }
    
    if (_selectedTimeRange != null) {
      // Parse time range like "09:00-12:00"
      if (_selectedTimeRange!.contains('-')) {
        List<String> parts = _selectedTimeRange!.split('-');
        String startTime = parts[0].trim();
        String endTime = parts[1].trim();
        
        _filteredClasses = _filteredClasses.where((c) {
          // Simple string comparison works if time is in format "HH:MM"
          return c.time.compareTo(startTime) >= 0 && c.time.compareTo(endTime) <= 0;
        }).toList();
      }
    }
  }
}