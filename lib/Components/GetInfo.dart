import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/auth_service.dart';
import '../pages/loginpage2.dart';

class GetInfo extends StatefulWidget {
  final User? user; // Correct user field
  const GetInfo({super.key, this.user});
  @override
  State<GetInfo> createState() => _GetInfoState();
}

class _GetInfoState extends State<GetInfo> {
 // Constructor name fixed
  final AuthService _authService = AuthService();
 // Create an instance of AuthService
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.user != null) // Check if user is not null
              Column(
                children: [
                  Text(
                    'Welcome, ${widget.user?.photoURL}', // Display user email
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut(); // Call the sign-out method
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => loginpage2()), // Navigate to login page after sign-out
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300], // Adjust button style
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
