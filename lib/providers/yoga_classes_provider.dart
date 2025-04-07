import 'package:flutter/foundation.dart';
import '../models/yoga_class.dart';
import '../services/api_service.dart';

class YogaClassesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<YogaClass> _classes = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<YogaClass> get classes => [..._classes];
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch all yoga classes
  Future<void> fetchClasses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final fetchedClasses = await _apiService.fetchYogaClasses();
      _classes = fetchedClasses;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Filter classes by day of week
  List<YogaClass> getClassesByDay(String day) {
    return _classes.where((yogaClass) => 
      yogaClass.dayOfWeek.toLowerCase() == day.toLowerCase()
    ).toList();
  }
  
  // Filter classes by time range (e.g., "morning", "afternoon", "evening")
  List<YogaClass> getClassesByTimeOfDay(String timeOfDay) {
    int startHour = 0;
    int endHour = 24;
    
    switch (timeOfDay.toLowerCase()) {
      case 'morning':
        startHour = 6;
        endHour = 12;
        break;
      case 'afternoon':
        startHour = 12;
        endHour = 17;
        break;
      case 'evening':
        startHour = 17;
        endHour = 22;
        break;
    }
    
    return _classes.where((yogaClass) {
      final hour = yogaClass.dateTime.hour;
      return hour >= startHour && hour < endHour;
    }).toList();
  }
  
  // Filter classes by specific time
  List<YogaClass> getClassesByTime(TimeOfDay time) {
    return _classes.where((yogaClass) {
      return yogaClass.dateTime.hour == time.hour && 
             yogaClass.dateTime.minute == time.minute;
    }).toList();
  }
  
  // Search classes by day and time
  List<YogaClass> searchClasses({String? day, String? timeOfDay, TimeOfDay? specificTime}) {
    List<YogaClass> filteredClasses = [..._classes];
    
    if (day != null && day.isNotEmpty) {
      filteredClasses = filteredClasses.where((yogaClass) => 
        yogaClass.dayOfWeek.toLowerCase() == day.toLowerCase()
      ).toList();
    }
    
    if (timeOfDay != null && timeOfDay.isNotEmpty) {
      int startHour = 0;
      int endHour = 24;
      
      switch (timeOfDay.toLowerCase()) {
        case 'morning':
          startHour = 6;
          endHour = 12;
          break;
        case 'afternoon':
          startHour = 12;
          endHour = 17;
          break;
        case 'evening':
          startHour = 17;
          endHour = 22;
          break;
      }
      
      filteredClasses = filteredClasses.where((yogaClass) {
        final hour = yogaClass.dateTime.hour;
        return hour >= startHour && hour < endHour;
      }).toList();
    }
    
    if (specificTime != null) {
      filteredClasses = filteredClasses.where((yogaClass) {
        return yogaClass.dateTime.hour == specificTime.hour && 
               yogaClass.dateTime.minute == specificTime.minute;
      }).toList();
    }
    
    return filteredClasses;
  }
}

class TimeOfDay {
  final int hour;
  final int minute;
  
  TimeOfDay({required this.hour, required this.minute});
}