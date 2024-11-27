import 'package:flutter/material.dart';
import 'package:map_flutter/screens/auth/login_screen.dart';
import 'package:map_flutter/screens/auth/register_screen.dart';
import '../../generated/l10n.dart'; // Import the generated localization class

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight, // Take full screen height
        decoration: const BoxDecoration(
            color: Colors.white), // Full screen background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spread items
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add space above the illustration
            Column(
              children: [
                SizedBox(height: screenHeight * 0.1), // Adjust height as needed
                // Illustration
                SizedBox(
                  height: screenHeight * 0.3,
                  child: Center(
                    child: Image.asset(
                      'assets/Illustration.png', // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            // Welcome Text Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    S
                        .of(context)
                        .welcome_screen_title, // Using the translated string
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S
                        .of(context)
                        .welcome_screen_message, // Using the translated string
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Buttons Section
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008955),
                      minimumSize: Size(screenWidth, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      S.of(context).welcome_screen_signUp,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(screenWidth, 54),
                      side: const BorderSide(color: Color(0xFF008955)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      S.of(context).welcome_screen_signIn,
                      style: TextStyle(
                        color: Color(0xFF008955),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
