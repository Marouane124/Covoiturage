import 'package:flutter/material.dart';
import 'package:map_flutter/screens/map_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF414141),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF414141),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () {
        // Action when menu item is tapped
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 249,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(80),
            bottomRight: Radius.circular(80),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF414141),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    ),
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(''),
            ),
            const SizedBox(height: 12),
            const Text(
              'Nate Samson',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'nate@email.com',
              style: TextStyle(
                color: Color(0xFF898989),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMenuItem(Icons.history, 'History'),
                    _buildMenuItem(Icons.warning_outlined, 'Complain'),
                    _buildMenuItem(Icons.people_outline, 'Referral'),
                    _buildMenuItem(Icons.info_outline, 'About Us'),
                    _buildMenuItem(Icons.settings_outlined, 'Settings'),
                    _buildMenuItem(Icons.help_outline, 'Help and Support'),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildMenuItem(Icons.logout, 'Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
