import 'package:flutter/material.dart';
import 'package:map_flutter/screens/map_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          ),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Professional Rideshare Platform. Here we will provide you only interesting content, which you will like very much. We\'re dedicated to providing you the best of Rideshare, with a focus on dependability and Earning. We\'re working to turn our passion for Rideshare into a booming online website. We hope you enjoy our Rideshare as much as we enjoy offering them to you. I will keep posting more important posts on my Website for all of you. Please give your support and love.Professional Rideshare Platform. Here we will provide you only interesting content, which you will like very much. We\'re dedicated to providing you the best of Rideshare, with a focus on dependability and Earning. We\'re working to turn our passion for Rideshare into a booming online website. We hope you enjoy our Rideshare as much as we enjoy offering them to you. I will keep posting more important posts on my Website for all of you. Please give your support and love.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF000000),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
