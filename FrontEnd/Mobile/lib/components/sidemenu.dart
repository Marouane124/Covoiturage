import 'package:flutter/material.dart';
import 'package:map_flutter/screens/sidemenu/history.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/screens/sidemenu/complain.dart';
import 'package:map_flutter/screens/sidemenu/referral.dart';
import 'package:map_flutter/screens/sidemenu/aboutus.dart';
import 'package:map_flutter/screens/sidemenu/settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_flutter/screens/sidemenu/driver_mode.dart';
import 'package:map_flutter/services/user_service.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  Uint8List? _profileImageBytes;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final profile = await _userService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
          _profileImagePath = profile['photoUrl'];
          if (profile['profileImage'] != null) {
            _profileImageBytes = base64Decode(profile['profileImage']);
          }
        });
      }
    } catch (e) {
      print('Erreur de chargement du profil: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
        } else if (title == 'Referral') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReferralScreen()),
          );
        } else if (title == 'About Us') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUsScreen()),
          );
        } else if (title == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        } else if (title == 'Driver Mode') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DriverMode()),
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
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF08B783), width: 1),
              ),
              child: ClipOval(
                child: _profileImageBytes != null
                    ? Image.memory(
                        _profileImageBytes!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF08B783),
                          );
                        },
                      )
                    : _profileImagePath != null
                        ? Image.file(
                            File(_profileImagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFF08B783),
                              );
                            },
                          )
                        : const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF08B783),
                          ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _userProfile?['username'] ?? 'Chargement...',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _isLoading 
                  ? 'Chargement...' 
                  : (_userProfile?['email'] ?? 'Email non disponible'),
              style: const TextStyle(
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
                    _buildMenuItem(context, Icons.help_outline, 'Driver Mode'),
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
