import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_flutter/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = AppConfig.baseUrl;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<bool> isLoggedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return false;

    final token = await getAccessToken();
    return token != null;
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String city,
  }) async {
    try {
      final String lowerCaseEmail = email.toLowerCase();

      print('\n=== Registration Data ===');
      print('Username: $username');
      print('Email: $lowerCaseEmail');
      print('Phone: $phone');
      print('Gender: $gender');
      print('City: $city');
      print('========================\n');

      // Map the localized gender to fixed values
      String mappedGender;
      if (gender.toLowerCase() == 'male' || gender.toLowerCase() == 'homme') {
        mappedGender = 'Homme';
      } else if (gender.toLowerCase() == 'female' ||
          gender.toLowerCase() == 'femme') {
        mappedGender = 'Femme';
      } else {
        throw Exception('Invalid gender value');
      }

      // Create Firebase user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: lowerCaseEmail,
        password: password,
      );

      // Update Firebase profile
      await userCredential.user?.updateDisplayName(username);

      // Create user data for MongoDB
      final Map<String, dynamic> userData = {
        'uid': userCredential.user!.uid,
        'username': username,
        'email': lowerCaseEmail,
        'phone': phone,
        'gender': mappedGender,
        'city': city,
        'password': password,
        'roles': ['PASSAGER'] // Set default role
      };

      try {
        final response = await _dio.post(
          '$baseUrl/signup',
          data: userData,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        print('\n=== API Response ===');
        print('Status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        print('==================\n');

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Save tokens if they're included in signup response
          if (response.data['accessToken'] != null &&
              response.data['refreshToken'] != null) {
            await saveTokens(
              response.data['accessToken'],
              response.data['refreshToken'],
            );
          }
          return true;
        }

        // If MongoDB storage fails, clean up Firebase user
        await userCredential.user?.delete();
        return false;
      } catch (e) {
        print('MongoDB Error: $e');
        // Clean up Firebase user if MongoDB storage fails
        await userCredential.user?.delete();
        throw Exception('Failed to store user data in database');
      }
    } on FirebaseAuthException catch (e) {
      print('=== Firebase Auth Error ===');
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      print('========================');
      throw Exception(_handleFirebaseError(e));
    } catch (e) {
      print('=== Signup Error ===');
      print('Type: ${e.runtimeType}');
      print('Message: $e');
      print('==================');
      throw Exception('Registration failed: $e');
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Registration failed: ${e.message}';
    }
  }

  Future<void> _cleanupFirebaseUser(User user) async {
    try {
      await user.delete();
      print('Firebase user cleanup successful');
    } catch (e) {
      print('Firebase cleanup error: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final String lowerCaseEmail = email.toLowerCase();

      print('\n=== Login Attempt ===');
      print('Email: $lowerCaseEmail');
      print('==================\n');

      // First authenticate with Firebase
      final UserCredential firebaseUser =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: lowerCaseEmail,
        password: password,
      );

      // If Firebase auth successful, authenticate with backend
      final response = await _dio.post(
        '$baseUrl/signin',
        data: {
          'email': lowerCaseEmail,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('\n=== Login Response ===');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('==================\n');

      if (response.statusCode == 200) {
        // Save token as access token (for now)
        await saveTokens(
          response.data['token'],
          response.data['token'],
        );

        return {
          'firebaseUser': firebaseUser.user,
          'apiResponse': response.data,
        };
      } else {
        throw Exception('Backend authentication failed');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      print('Login Error: $e');
      throw Exception('Login failed: $e');
    }
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Login failed: ${e.message}';
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('Sign-out failed: $e');
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Dio getDioWithAuth() {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              final newTokens = await refreshTokens();
              error.requestOptions.headers['Authorization'] =
                  'Bearer ${newTokens['accessToken']}';
              return handler.resolve(await dio.fetch(error.requestOptions));
            } catch (e) {
              await signOut();
              // Navigate to login screen
            }
          }
          return handler.next(error);
        },
      ),
    );
    return dio;
  }

  Future<Map<String, dynamic>> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) throw Exception('No refresh token found');

      final response = await _dio.post(
        '$baseUrl/auth/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        await saveTokens(
          response.data['accessToken'],
          response.data['refreshToken'],
        );
        return response.data;
      }
      throw Exception('Failed to refresh tokens');
    } catch (e) {
      await signOut();
      throw Exception('Session expired. Please login again.');
    }
  }
}
