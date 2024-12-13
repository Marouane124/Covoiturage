import 'package:flutter/material.dart';
import 'package:map_flutter/screens/auth/register_screen.dart';
import 'package:map_flutter/screens/auth/welcome_screen.dart';
import 'package:map_flutter/services/auth_service.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/widgets/auth_wrapper.dart';
import '../../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  final String? initialUsername;
  final String? initialPassword;

  const LoginScreen({
    Key? key,
    this.initialUsername,
    this.initialPassword,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Toggles password visibility
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUsername != null) {
      _emailController.text = widget.initialUsername!;
    }
    if (widget.initialPassword != null) {
      _passwordController.text = widget.initialPassword!;
    }
  }

  // Helper methods for building fields and buttons
  Widget _buildEmailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: S.of(context).login_screen_email,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: S.of(context).login_screen_password,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: const Color(0xFF008955),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              S.of(context).login_screen_signIn,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }

  Widget _buildSocialButton(BuildContext context,
      {required IconData icon,
      required String text,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSocialMediaButtons(BuildContext context) {
    return Column(
      children: [
        _buildSocialButton(
          context,
          icon: Icons.email,
          text: S.of(context).login_screen_sign_in_with_google,
          color: Colors.red,
          onPressed: () {
            // Gmail sign-in logic
          },
        ),
        const SizedBox(height: 10),
        _buildSocialButton(
          context,
          icon: Icons.facebook,
          text: S.of(context).login_screen_sign_in_with_facebook,
          color: Colors.blue,
          onPressed: () {
            // Facebook sign-in logic
          },
        ),
        const SizedBox(height: 10),
        _buildSocialButton(
          context,
          icon: Icons.apple,
          text: S.of(context).login_screen_sign_in_with_apple,
          color: Colors.black,
          onPressed: () {
            // Apple sign-in logic
          },
        ),
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      },
      child: Text(
        S.of(context).login_screen_signUp,
        style: const TextStyle(color: Colors.green, fontSize: 14),
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Forgot password logic
      },
      child: Text(
        S.of(context).login_screen_forgot_password,
        style: const TextStyle(color: Colors.red, fontSize: 14),
      ),
    );
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted && result['firebaseUser'] != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AuthWrapper(
              child: MapScreen(),
              requireAuth: true,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).login_screen_title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildEmailField(context),
              const SizedBox(height: 20),
              _buildPasswordField(context),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: _buildForgotPasswordLink(context),
              ),
              const SizedBox(height: 40),
              _buildSignInButton(context),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black.withOpacity(0.6),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        S.of(context).login_screen_or,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black.withOpacity(0.6),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSocialMediaButtons(context),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: _buildSignUpLink(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
