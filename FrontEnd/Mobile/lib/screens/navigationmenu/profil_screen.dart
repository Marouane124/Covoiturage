import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:map_flutter/services/user_service.dart';
import 'package:map_flutter/components/bottom_navigation_bar.dart';
import 'map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_flutter/screens/auth/welcome_screen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = 'Homme';
  String? _profileImagePath;
  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF5A5A5A),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String value,
    bool enabled = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldTitle(title),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF08B783)),
            ),
            contentPadding: const EdgeInsets.all(20),
            hintText: value,
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userService.getCurrentUserProfile();
      setState(() {
        _userProfile = profile;
        _phoneController.text = profile['phone'] ?? '';
        _selectedGender = profile['gender'] == 'Male'
            ? 'Homme'
            : profile['gender'] ?? 'Homme';
        _isLoading = false;
        _profileImagePath = profile['photoUrl'];
        if (profile['profileImage'] != null) {
          _profileImageBytes = base64Decode(profile['profileImage']);
        }
      });
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: <String>['Homme', 'Femme', 'Autre']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue!;
        });
      },
      validator: (value) => value == null ? 'Please select a gender' : null,
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
      await _uploadProfileImage(File(image.path));
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      await _userService.updateUserProfileImage(image);
      _loadUserProfile();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConductor = _userProfile?['role'] == 'conducteur';

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.white,
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8AD4B5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
          title: const Text(
            'Profile',
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Profile Image
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 138,
                          height: 138,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF08B783), width: 1),
                            color: const Color(0xFFE2F5ED),
                          ),
                          child: _profileImageBytes != null
                              ? ClipOval(
                                  child: Image.memory(
                                    _profileImageBytes!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Color(0xFF08B783),
                                      );
                                    },
                                  ),
                                )
                              : _profileImagePath != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(_profileImagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            size: 80,
                                            color: Color(0xFF08B783),
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Color(0xFF08B783),
                                    ),
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F5ED),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF08B783), width: 1),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: Color(0xFF08B783),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Username
                Center(
                  child: Text(
                    _userProfile?['username'] ?? 'Loading...',
                    style: const TextStyle(
                      color: Color(0xFF5A5A5A),
                      fontSize: 28,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Basic Info Fields
                _buildTextField(
                  title: 'Email',
                  value: _userProfile?['email'] ?? 'Loading...',
                ),
                _buildTextField(
                  title: 'Phone',
                  value: _userProfile?['phone'] ?? 'Enter your phone number',
                  enabled: true,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                // Gender Selection
                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldTitle('Gender'),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFB8B8B8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF08B783)),
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      items: ['Homme', 'Femme'].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                */
                const SizedBox(height: 16),
                _buildTextField(
                  title: 'City',
                  value: _userProfile?['city'] ?? 'Enter your city',
                  enabled: true,
                ),
                // Conductor-specific fields
                if (isConductor) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Vehicle Information',
                    style: TextStyle(
                      color: Color(0xFF2A2A2A),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    title: 'Vehicle Model',
                    value: _userProfile?['vehicleModel'] ?? '',
                    enabled: true,
                  ),
                  _buildTextField(
                    title: 'License Number',
                    value: _userProfile?['licenseNumber'] ?? '',
                    enabled: true,
                  ),
                  _buildTextField(
                    title: 'Vehicle Type',
                    value: _userProfile?['vehicleType'] ?? '',
                    enabled: true,
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08B783),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
      ),
    );
  }
}
