import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help and Support',
          style: TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help and Support for Ride share',
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Lorem ipsum dolor sit amet consectetur. Sit pulvinar mauris mauris eu nibh semper nisl pretium laoreet. Sed non faucibus ac lectus eu arcu. Nulla sit congue facilisis vestibulum egestas nisl feugiat pharetra. Odio sit tortor morbi at orci ipsum dapibus interdum. Lorem felis est aliquet arcu nullam pellentesque. Et habitasse ac arcu et nunc euismod rhoncus facilisis sollicitudin.',
                style: TextStyle(
                  color: Color(0xFF717171),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}