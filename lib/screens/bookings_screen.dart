import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import '../models/class_instance.dart';
import '../models/yoga_class.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    if (bookingProvider.userEmail != null) {
      _emailController.text = bookingProvider.userEmail!;
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final userEmail = bookingProvider.userEmail;
    final bookings = bookingProvider.userBookings;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: userEmail == null
          ? _buildEmailForm()
          : bookings.isEmpty
              ? const Center(
                  child: Text('You have no bookings yet'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return _buildBookingCard(context, bookings[index]);
                  },
                ),
    );
  }
  
  Widget _buildEmailForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter your email to view your bookings',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_emailController.text.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });
                        
                        // Set user email and fetch bookings
                        final bookingProvider = Provider.of<BookingProvider>(
                          context, 
                          listen: false,
                        );
                        bookingProvider.setUserEmail(_emailController.text);
                        
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('View Bookings'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.id.substring(0, 8)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(booking.bookingDate),
                ),
              ],
            ),
            const Divider(),
            Text('Total: \$${booking.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Classes: ${booking.classIds.length}'),
            const SizedBox(height: 16),
            _buildBookingClasses(context, booking),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBookingClasses(BuildContext context, Booking booking) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    
    return FutureBuilder<List<ClassInstance>>(
      future: bookingProvider.getBookedClassInstances(booking),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        final instances = snapshot.data ?? [];
        
        if (instances.isEmpty) {
          return const Text('No class details available');
        }
        
        return Column(
          children: instances.map((instance) {
            return FutureBuilder<YogaClass?>(
              future: bookingProvider.getYogaClassForInstance(instance),
              builder: (context, yogaClassSnapshot) {
                if (yogaClassSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Loading...'),
                  );
                }
                
                final yogaClass = yogaClassSnapshot.data;
                
                return ListTile(
                  title: Text(yogaClass?.name ?? 'Unknown Class'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('EEEE, MMMM d, yyyy').format(instance.date)),
                      Text('Time: ${DateFormat('h:mm a').format(instance.date)}'),
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
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}