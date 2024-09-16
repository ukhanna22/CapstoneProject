import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'wellness_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyALazYdYNXFhyud_wtyCphB3JrMh2o5NY4',
        appId: '1:789264753969:android:5827a29f9835222694fc10',
        messagingSenderId: '789264753969-e3dilc6mr3706iolq21l8ofc2g6g7ku2.apps.googleusercontent.com',
        projectId: 'nutrition-tpkhuj',
        storageBucket: 'nutrition-tpkhuj.appspot.com',
      )
  );  // Ensures Firebase is initialized before running the app
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
