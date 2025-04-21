import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/yoga_class.dart';
import '../models/class_instance.dart';
import '../models/cart_item.dart';
import '../providers/class_provider.dart';
import '../providers/booking_provider.dart';

class ClassDetailScreen extends StatelessWidget {
  final YogaClass yogaClass;
  
  const ClassDetailScreen({super.key, required this.yogaClass});

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(yogaClass.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class details
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yogaClass.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      yogaClass.type,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      yogaClass.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(context, 'Day', yogaClass.dayOfWeek),
                    _buildInfoRow(context, 'Time', yogaClass.time),
                    _buildInfoRow(context, 'Duration', '${yogaClass.duration} minutes'),
                    _buildInfoRow(context, 'Capacity', yogaClass.capacity.toString()),
                    _buildInfoRow(context, 'Price', '\$${yogaClass.price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            
            // Upcoming class instances
            Text(
              'Upcoming Classes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<ClassInstance>>(
              stream: classProvider.getUpcomingClassInstancesForCourse(yogaClass.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                
                final instances = snapshot.data ?? [];
                
                if (instances.isEmpty) {
                  return const Center(
                    child: Text('No upcoming classes available.'),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: instances.length,
                  itemBuilder: (context, index) {
                    final instance = instances[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(instance.date),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time: ${DateFormat('h:mm a').format(instance.date)}'),
                            Text('Teacher: ${instance.teacherName}'),
                            if (instance.comments.isNotEmpty)
                              Text('Notes: ${instance.comments}'),
                            if (instance.isCancelled)
                              const Text(
                                'CANCELLED',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        trailing: instance.isCancelled
                            ? null
                            : ElevatedButton(
                                onPressed: () {
                                  bookingProvider.addToCart(
                                    CartItem(
                                      classInstance: instance,
                                      yogaClass: yogaClass,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text('Add to Cart'),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}