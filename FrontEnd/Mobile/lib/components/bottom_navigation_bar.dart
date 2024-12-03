import 'package:flutter/material.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/screens/navigationmenu/favorite.dart';
import 'package:map_flutter/screens/navigationmenu/profil_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  Widget _buildMenuItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF08B783),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Wallet',
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuItem(
            Icons.home,
            'Home',
            currentIndex == 0 ? const Color(0xFF08B783) : const Color(0xFF414141),
            () {
              if (currentIndex != 0) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                  (route) => false,
                );
              }
            },
          ),
          _buildMenuItem(
            Icons.favorite,
            'Favourite',
            currentIndex == 1 ? const Color(0xFF08B783) : const Color(0xFF414141),
            () {
              if (currentIndex != 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                );
              }
            },
          ),
          _buildWalletButton(),
          _buildMenuItem(
            Icons.local_offer,
            'Offer',
            const Color(0xFF414141),
            () {},
          ),
          _buildMenuItem(
            Icons.person,
            'Profile',
            currentIndex == 4 ? const Color(0xFF08B783) : const Color(0xFF414141),
            () {
              if (currentIndex != 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}