import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/auth/welcome_screen.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;
  final AuthService authService;

  const AuthMiddleware({
    super.key,
    required this.child,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data == true) {
          return child;
        }

        return const WelcomeScreen();
      },
    );
  }
}
