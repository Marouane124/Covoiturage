import 'package:flutter/material.dart';
import 'package:map_flutter/screens/auth/register_screen.dart';
import '../../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // This will navigate back to the previous screen in the stack
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: SafeArea(
        child: SingleChildScrollView(
          // Added this widget to make the screen scrollable
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).login_screen_title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Email or Phone Number Field
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: S.of(context).login_screen_email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: S.of(context).login_screen_password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Forget Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Implement the forget password logic
                    },
                    child: Text(
                      S.of(context).login_screen_forgot_password,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    // Handle sign in logic
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF008955), // Green color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    S.of(context).login_screen_signIn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // OR Divider
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

                // Social Media Buttons (Gmail, Facebook, Apple)
                Column(
                  children: [
                    // Gmail Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implement Gmail sign-in logic
                      },
                      icon: const Icon(Icons.email, color: Colors.white),
                      label: Text(
                        S.of(context).login_screen_sign_in_with_google,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red, // Gmail color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Facebook Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implement Facebook sign-in logic
                      },
                      icon: const Icon(Icons.facebook, color: Colors.white),
                      label: Text(
                        S.of(context).login_screen_sign_in_with_facebook,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue, // Facebook color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Apple Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Implement Apple sign-in logic
                      },
                      icon: const Icon(Icons.apple, color: Colors.white),
                      label: Text(
                        S.of(context).login_screen_sign_in_with_apple,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black, // Apple color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign Up Text
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          S.of(context).login_screen_signUp,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
