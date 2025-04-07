import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/yoga_class.dart';
import '../providers/cart_provider.dart';

class ClassDetailScreen extends StatelessWidget {
  final YogaClass yogaClass;

  const ClassDetailScreen({
    Key? key,
    required this.yogaClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isInCart(yogaClass);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(yogaClass.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class title
            Text(
              yogaClass.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            
            // Instructor
            Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Instructor: ${yogaClass.instructor}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Date and time
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Date: ${DateFormat('EEEE, MMMM d, yyyy').format(yogaClass.dateTime)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Time: ${DateFormat('h:mm a').format(yogaClass.dateTime)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Duration
            Row(
              children: [
                const Icon(Icons.timelapse, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Duration: ${yogaClass.duration} minutes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Availability
            Row(
              children: [
                Icon(
                  yogaClass.isAvailable ? Icons.check_circle : Icons.cancel,
                  size: 20,
                  color: yogaClass.isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Availability: ${yogaClass.enrolled}/${yogaClass.capacity} enrolled',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: yogaClass.isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Price
            Row(
              children: [
                const Icon(Icons.attach_money, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Price: \$${yogaClass.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              yogaClass.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Add to cart button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: yogaClass.isAvailable && !isInCart
                    ? () {
                        cartProvider.addItem(yogaClass);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${yogaClass.title} added to cart'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cartProvider.removeItem(yogaClass.id);
                              },
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isInCart
                      ? 'Already in Cart'
                      : yogaClass.isAvailable
                          ? 'Add to Cart'
                          : 'Class Full',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}