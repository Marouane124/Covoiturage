import 'package:flutter/material.dart';

class DriverDetailsScreen extends StatelessWidget {
  final String username;
  final String email;
  final String phone;
  final String city;

  DriverDetailsScreen({
    required this.username,
    required this.email,
    required this.phone,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Details'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: $email', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: $phone', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('City: $city', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}