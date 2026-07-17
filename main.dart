import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:oran_ride/services/firebase_service.dart';
import 'package:oran_ride/screens/auth_screen.dart';
import 'package:oran_ride/screens/rider_home.dart';
import 'package:oran_ride/screens/driver_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseService()),
      ],
      child: const OranRideApp(),
    ),
  );
}

class OranRideApp extends StatelessWidget {
  const OranRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oran Ride',
      theme: ThemeData(
        primarySwatch: Colors.emerald,
        primaryColor: const Color(0xFF10B981), // Oran Ride Algerian Green
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      locale: const Locale('ar', 'DZ'), // Default Oran Arabic Locale
      supportedLocales: const [
        Locale('ar', 'DZ'), // Arabic
        Locale('fr', 'DZ'), // French
        Locale('en', 'US'), // English
      ],
      home: const AuthScreen(),
      routes: {
        '/rider_home': (context) => const RiderHomeScreen(),
        '/driver_home': (context) => const DriverHomeScreen(),
      },
    );
  }
}
