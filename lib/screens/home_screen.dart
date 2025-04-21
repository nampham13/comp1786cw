import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/class_provider.dart';
import '../models/yoga_class.dart';
import '../widgets/class_card.dart';
import '../widgets/filter_bar.dart';
import 'cart_screen.dart';
import 'bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const FilterBar(),
          Expanded(
            child: Consumer<ClassProvider>(
              builder: (context, classProvider, child) {
                final classes = classProvider.filteredClasses;
                
                if (classes.isEmpty) {
                  return const Center(
                    child: Text('No classes found. Try adjusting your filters.'),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    return ClassCard(yogaClass: classes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}