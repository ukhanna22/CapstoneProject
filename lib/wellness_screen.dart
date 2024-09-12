import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WellnessScreen extends StatefulWidget {
  @override
  _WellnessScreenState createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness AI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.redAccent,
                tabs: [
                  Tab(text: 'Create Account'),
                  Tab(text: 'Log In'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                width: double.infinity,
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: AlignmentDirectional.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/wai.png',
                    width: 223,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Container(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SignUpScreen(),  // Calls the SignUpScreen
                  LoginScreen(),   // Calls the LoginScreen
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
