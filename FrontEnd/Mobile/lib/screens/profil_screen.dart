import 'package:flutter/material.dart';
import 'package:map_flutter/screens/map_screen.dart';
import 'package:map_flutter/screens/favorite.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () => Navigator.pop(context),
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
            children: [
              const SizedBox(height: 20),
              // Profile Image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 138,
                    height: 138,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF08B783), width: 1),
                      image: const DecorationImage(
                        image: NetworkImage("https://via.placeholder.com/138x138"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F5ED),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF08B783), width: 1),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 12,
                      color: Color(0xFF08B783),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Name
              const Text(
                'Nate Samson',
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 28,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              // Email Field
              TextField(
                enabled: false,
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
                  hintText: 'nate@email.com',
                  hintStyle: const TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone Field
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF08B783)),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  hintText: 'Your mobile number',
                  prefixText: '+880 ',
                  prefixStyle: const TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Gender Field
              DropdownButtonFormField<String>(
                value: _selectedGender,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF08B783)),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
                items: ['Male', 'Female'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: const TextStyle(
                        color: Color(0xFF5A5A5A),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Address Field
              TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFB8B8B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF08B783)),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  hintText: 'Address',
                ),
              ),
              const SizedBox(height: 24),
              // Logout Button
              OutlinedButton(
                onPressed: () {
                  // Add logout logic here
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  side: const BorderSide(color: Color(0xFF008955)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFF008955),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFEEEEEE)),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: 4,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Offer'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedItemColor: const Color(0xFF08B783),
          unselectedItemColor: const Color(0xFF414141),
          onTap: (index) {
            switch (index) {
              case 0: // Home
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                  (route) => false,
                );
                break;
              case 1: // Favourite
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                );
                break;
              case 4: // Profile - current screen, no action needed
                break;
            }
          },
        ),
      ),
    );
  }
}
