// lib/screens/transport/screens/driver_details_screen.dart
import 'package:flutter/material.dart';

class DriverDetailsScreen extends StatelessWidget {
  final String driverName;
  final String carModel;
  final String seats;
  final String price;
  final String distance;
  final String imageUrl;

  const DriverDetailsScreen({
    Key? key,
    required this.driverName,
    required this.carModel,
    required this.seats,
    required this.price,
    required this.distance,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 86, 83, 83),
      appBar: AppBar(
        title: Text(driverName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Car Model: $carModel',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'Seats: $seats',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'Price: $price',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              'Distance: $distance',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}