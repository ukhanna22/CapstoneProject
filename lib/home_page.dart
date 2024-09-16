import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name;

  HomePage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Text('Hi, $name!'),  // Display the user's name
      ),
    );
  }
}
