import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'signup_screen.dart';  // Assuming you have a SignUpScreen for registration

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // For controlling password visibility

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Log In with Email and Password
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String name = await _getUserName(userCredential.user!.uid);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged in successfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(name: name)),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found for that email. Please sign up first.')));
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect password. Please try again.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to log in: ${e.message}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to log in')));
      }
    }
  }

  // Log In with Google
  Future<void> _loginWithGoogle() async {
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-In successful')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(name: googleUser.displayName ?? 'User')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to log in with Google: ${e.toString()}')));
    }
  }

  // Get user's name from Firestore
  Future<String> _getUserName(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc['name'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Email Login Form
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),

          // Password Field with Visibility Toggle
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

          // Login Button
          ElevatedButton(
            onPressed: _login,
            child: Text('Log In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,  // Set text color to white
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Google Sign-In Button
          ElevatedButton.icon(
            onPressed: _loginWithGoogle,
            icon: Image.asset('assets/google.png', height: 24),  // Use the Google icon
            label: Text('Sign in with Google'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,  // Set icon and text color
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey),  // Optional: Add border color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
