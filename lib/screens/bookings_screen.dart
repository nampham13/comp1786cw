import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      await Provider.of<BookingProvider>(context, listen: false)
          .fetchUserBookings(_emailController.text);
    } catch (error) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching bookings: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email input and search button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email to find bookings',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _fetchBookings,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('SEARCH'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Bookings list
            Expanded(
              child: !_hasSearched
                  ? const Center(
                      child: Text(
                        'Enter your email to view your bookings',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : bookingProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : bookingProvider.error != null
                          ? Center(
                              child: Text(
                                'Error: ${bookingProvider.error}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : bookingProvider.bookings.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No bookings found for this email',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: bookingProvider.bookings.length,
                                  itemBuilder: (ctx, i) {
                                    final booking = bookingProvider.bookings[i];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Booking ID and date
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Booking #${booking.id}',
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                ),
                                                Text(
                                                  DateFormat('MMM d, yyyy').format(booking.bookingDate),
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            
                                            // Classes in this booking
                                            ...booking.classes.map((yogaClass) => Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.fitness_center, size: 20),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          yogaClass.title,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          '${DateFormat('EEEE, MMMM d').format(yogaClass.dateTime)} at ${DateFormat('h:mm a').format(yogaClass.dateTime)}',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text('\$${yogaClass.price.toStringAsFixed(2)}'),
                                                ],
                                              ),
                                            )).toList(),
                                            
                                            const Divider(),
                                            
                                            // Total amount
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                const Text('Total: '),
                                                Text(
                                                  '\$${booking.totalAmount.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
            ),
          ],
        ),
      ),
    );
  }
}