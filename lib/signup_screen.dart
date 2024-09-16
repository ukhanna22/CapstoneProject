import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart'; // Assuming HomePage is where the user goes after sign-up

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // For controlling password visibility

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Account with Email, Password, and Name
  Future<void> _createAccount() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;

      // Store the user's name in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created successfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(name: _nameController.text.trim())),
      );
    } catch (e) {
      print('Failed to create account: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create account')));
    }
  }

  // Sign Up with Google
  Future<void> _signUpWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      String uid = userCredential.user!.uid;

      // Check if user already exists in Firestore, if not, store their name and email
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(uid).set({
          'name': googleUser.displayName,
          'email': googleUser.email,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-Up successful')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(name: googleUser.displayName ?? 'User')),
      );
    } catch (e) {
      print('Failed to sign up with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign up with Google')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Name Input Field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),

          // Email Input Field
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),

          // Password Input Field with Visibility Toggle
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword; // Toggle visibility
                  });
                },
              ),
            ),
            obscureText: _obscurePassword, // Control password visibility
          ),
          SizedBox(height: 20),

          // Create Account Button
          ElevatedButton(
            onPressed: _createAccount,
            child: Text('Create Account'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Sign-Up with Google Button
          ElevatedButton.icon(
            onPressed: _signUpWithGoogle,
            icon: Image.asset('assets/google.png', height: 24),  // Google Icon
            label: Text('Sign up with Google'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey),  // Optional border color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
