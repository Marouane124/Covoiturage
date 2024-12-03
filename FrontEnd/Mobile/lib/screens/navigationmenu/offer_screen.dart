import 'package:flutter/material.dart';
import 'dart:ui';  // Add this import for BackdropFilter
import '../../components/bottom_navigation_bar.dart';
import '../../components/sidemenu.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(  // Changed to IconButton
          icon: const Icon(Icons.menu, color: Colors.black),  // Updated icon style
          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
        title: const Text(
          'Offer',
          style: TextStyle(
            color: Colors.black,  // Updated text color
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              itemCount: offers.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildOfferCard(offers[index]),
              ),
            ),
          ),
          if (_isMenuOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  color: Colors.black.withOpacity(0.02),
                ),
              ),
            ),
          if (_isMenuOpen)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SideMenu(),
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFF08B783),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3D000000),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${offer.discount}% off',
                    style: TextStyle(
                      color: Color(0xFFF57F17),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    offer.title,
                    style: TextStyle(
                      color: Color(0xFFB8B8B8),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () {
                // Handle collect button tap
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF008955),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                minimumSize: Size(0, 36), // Reduced button height
              ),
              child: Text(
                'Collect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Offer {
  final String title;
  final int discount;

  Offer({required this.title, required this.discount});
}

final List<Offer> offers = [
  Offer(title: 'Black Friday', discount: 15),
  Offer(title: 'Crismus', discount: 5),
  Offer(title: 'Happy New Year', discount: 15),
  Offer(title: 'Black Friday', discount: 15),
  Offer(title: 'Crismus', discount: 5),
  Offer(title: 'Happy New Year', discount: 15),
  Offer(title: 'Black Friday', discount: 15),
  Offer(title: 'Crismus', discount: 5),
]; 