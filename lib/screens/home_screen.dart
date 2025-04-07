import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/yoga_classes_provider.dart';
import '../widgets/class_list.dart';
import '../widgets/search_filter.dart';
import 'cart_screen.dart';
import 'bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedDay;
  String? _selectedTimeOfDay;
  bool _isInit = true;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<YogaClassesProvider>(context).fetchClasses();
      _isInit = false;
    }
  }

  void _applyFilters(String? day, String? timeOfDay) {
    setState(() {
      _selectedDay = day;
      _selectedTimeOfDay = timeOfDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final classesProvider = Provider.of<YogaClassesProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CartScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const BookingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          SearchFilter(
            onApplyFilters: _applyFilters,
          ),
          
          // Classes list
          Expanded(
            child: classesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : classesProvider.error != null
                    ? Center(
                        child: Text(
                          'Error: ${classesProvider.error}',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ClassList(
                        classes: classesProvider.searchClasses(
                          day: _selectedDay,
                          timeOfDay: _selectedTimeOfDay,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}