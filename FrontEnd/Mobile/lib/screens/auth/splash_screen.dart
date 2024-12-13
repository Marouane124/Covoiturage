import 'package:flutter/material.dart';
import 'package:map_flutter/services/auth_service.dart';
import 'welcome_screen.dart';
import '../navigationmenu/map_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _handleNavigation();
  }

  void _initializeAnimation() {
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(2.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    _slideController.forward();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final isLoggedIn = await _authService.isLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const MapScreen() : const WelcomeScreen(),
      ),
    );
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
