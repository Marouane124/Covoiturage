import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../services/auth_service.dart'; 
import 'package:map_flutter/screens/auth/login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRole; 
  final List<String> roles = ['PASSAGER','CONDUCTEUR'];
  String? _selectedGender = 'Male'; 
  bool _isLoading = false;

  final AuthService _authService = AuthService();
  

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() async {
  if (_usernameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _selectedRole == null ||
      _selectedGender == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields')),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  final data = {
    'username': _usernameController.text,
    'email': _emailController.text,
    'password': _passwordController.text,
    'phone': _phoneController.text,
    'gender': _selectedGender!,
    'roles': [_selectedRole!],
  };

  print("Request Payload: $data"); // For debugging purposes

  try {
    // Call the sign-up service
    await _authService.signup(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      gender: _selectedGender!,
      roles: [_selectedRole!],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign-up successful')),
    );

    // Navigate to LoginScreen with credentials
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          initialUsername: _usernameController.text,
          initialPassword: _passwordController.text,
        ),
      ),
    );
  } catch (e) {
    print('Sign-up error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign-up failed: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).register_screen_title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Name Field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).register_screen_name,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                const SizedBox(height: 20),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: S.of(context).register_screen_email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),

                
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: S.of(context).register_screen_password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                const SizedBox(height: 20),

                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: S.of(context).register_screen_phone,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                const SizedBox(height: 20),

                // Gender Field
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: S.of(context).register_screen_gender,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: <String>['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)), 
                    );
                  }).toList(),
                  value: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Role Selection Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: S.of(context).register_screen_role,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: roles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black), 
                      ),
                    );
                  }).toList(),
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  style: TextStyle(color: Colors.black), 
                ),


                const SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF008955),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          S.of(context).register_screen_signUp,
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
                          S.of(context).register_screen_or,
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
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.email, color: Colors.white),
                      label: Text(
                        S.of(context).register_screen_sign_up_with_google,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook, color: Colors.white),
                      label: Text(
                        S.of(context).register_screen_sign_up_with_facebook,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple, color: Colors.white),
                      label: Text(
                        S.of(context).register_screen_sign_up_with_apple,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
