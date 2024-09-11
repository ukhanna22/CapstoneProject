import 'package:flutter/material.dart';

void main() {
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
      home: CreateAccountScreen(),
    );
  }
}

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                height: 100,
                child: Image.asset('C:/Users/ukhan/StudioProjects/wellness_ai/android/assets/wai.png'), // Use your logo asset here
              ),
              SizedBox(height: 20),

              // Create Account Form
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Tab Bar (Create Account / Log In)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 20),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    // Email TextField
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Password TextField
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.visibility_off),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Get Started'),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Or sign up with
                    Text('Or sign up with', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),

                    // Google and Apple Sign-Up Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Button
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset('C:/Users/ukhan/StudioProjects/wellness_ai/android/assets/google.png'), // Add your Google logo asset
                          ),
                        ),
                        SizedBox(width: 20),


                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
