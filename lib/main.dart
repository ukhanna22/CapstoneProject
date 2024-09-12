import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'wellness_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Ensures Firebase is initialized before running the app
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness AI',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: WellnessScreen(), // Calls the main wellness screen
    );
  }
}
