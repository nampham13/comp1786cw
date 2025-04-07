import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/yoga_class.dart';
import '../screens/class_detail_screen.dart';

class ClassList extends StatelessWidget {
  final List<YogaClass> classes;

  const ClassList({
    Key? key,
    required this.classes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return const Center(
        child: Text(
          'No classes found. Try adjusting your filters.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: classes.length,
      itemBuilder: (ctx, i) => Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ClassDetailScreen(yogaClass: classes[i]),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        classes[i].title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        '\$${classes[i].price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Instructor
                Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      classes[i].instructor,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Date and time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('EEEE, MMMM d').format(classes[i].dateTime),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('h:mm a').format(classes[i].dateTime),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${classes[i].duration} min)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Availability
                Row(
                  children: [
                    Icon(
                      classes[i].isAvailable ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: classes[i].isAvailable ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      classes[i].isAvailable
                          ? 'Available (${classes[i].capacity - classes[i].enrolled} spots left)'
                          : 'Class Full',
                      style: TextStyle(
                        color: classes[i].isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}