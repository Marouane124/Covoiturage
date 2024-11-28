import 'package:flutter/material.dart';
import 'package:map_flutter/screens/history.dart';
import 'package:map_flutter/screens/map_screen.dart';
import 'package:map_flutter/screens/complain.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
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
        if (title == 'History') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const History()),
          );
        } else if (title == 'Complain') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Complain()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 249,
      height: 853,
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
                    _buildMenuItem(context, Icons.history, 'History'),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    _buildMenuItem(context, Icons.warning_outlined, 'Complain'),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    _buildMenuItem(context, Icons.people_outline, 'Referral'),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    _buildMenuItem(context, Icons.info_outline, 'About Us'),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    _buildMenuItem(context, Icons.settings_outlined, 'Settings'),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    _buildMenuItem(context, Icons.help_outline, 'Help and Support'),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildMenuItem(context, Icons.logout, 'Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
