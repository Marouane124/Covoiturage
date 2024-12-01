import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          'Settings',
          style: TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildSettingItem(
              context,
              'Change Password',
              onTap: () => Navigator.pushNamed(context, '/change-password'),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              context,
              'Change Language',
              onTap: () => Navigator.pushNamed(context, '/change-language'),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              context,
              'Privacy Policy',
              onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              context,
              'Contact Us',
              onTap: () => Navigator.pushNamed(context, '/contact-us'),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              context,
              'Delete Account',
              onTap: () => Navigator.pushNamed(context, '/delete-account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 51,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF08B783)),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3D000000),
              blurRadius: 1,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF414141),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
