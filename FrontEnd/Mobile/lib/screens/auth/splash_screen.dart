import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Your WelcomeScreen or login screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the slide animation controller
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 3), // Increase duration to let the logo slide completely
    );

    // Define a slide animation (slide from left to right across the screen)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start off-screen on the left
      end: const Offset(2.0, 0.0), // End off-screen on the right
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    // Start the animation
    _slideController.forward();

    // Navigate to the next screen after the animation is complete
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _slideController
        .dispose(); // Dispose of the controller when the screen is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SlideTransition(
          position: _slideAnimation, // Apply the slide-in animation to the logo
          child: Image.asset(
            'assets/Logo.png', // Path to your logo image
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
