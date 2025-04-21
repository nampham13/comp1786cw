import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../services/firebase_service.dart';
import '../providers/class_provider.dart';
import '../providers/booking_provider.dart';
import '../utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (_) => FirebaseService(),
        ),
        ChangeNotifierProxyProvider<FirebaseService, ClassProvider>(
          create: (context) => ClassProvider(
            Provider.of<FirebaseService>(context, listen: false),
          ),
          update: (context, firebaseService, previous) => 
            ClassProvider(firebaseService),
        ),
        ChangeNotifierProxyProvider<FirebaseService, BookingProvider>(
          create: (context) => BookingProvider(
            Provider.of<FirebaseService>(context, listen: false),
          ),
          update: (context, firebaseService, previous) => 
            BookingProvider(firebaseService),
        ),
      ],
      child: MaterialApp(
        title: 'Yoga Class Booking',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}