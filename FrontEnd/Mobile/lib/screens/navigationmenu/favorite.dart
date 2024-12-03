import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/components/sidemenu.dart';
import 'package:map_flutter/screens/navigationmenu/profil_screen.dart';
import 'package:map_flutter/components/bottom_navigation_bar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isMenuOpen = false;

  Widget _buildFavoriteItem(String title, String address) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Text(
          address,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Logique pour supprimer l'élément
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
        title: const Text(
          'Favourite',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _buildFavoriteItem('Office', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('Home', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('Office', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('House', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('Home', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('Office', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('House', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
              _buildFavoriteItem('House', '2972 Westheimer Rd. Santa Ana, Illinois 85486'),
            ],
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
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
