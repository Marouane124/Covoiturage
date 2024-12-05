import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://192.168.1.161:8080/api';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String city,
  }) async {
    try {
      print('\n=== Registration Data ===');
      print('Username: $username');
      print('Email: $email');
      print('Phone: $phone');
      print('Gender: $gender');
      print('City: $city');
      print('========================\n');

      // Create Firebase user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update Firebase profile
      await userCredential.user?.updateDisplayName(username);

      // Create user data for MongoDB
      final Map<String, dynamic> userData = {
        'uid': userCredential.user!.uid,
        'username': username,
        'email': email,
        'phone': phone,
        'gender': gender,
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
      print('\n=== Login Attempt ===');
      print('Email: $email');
      print('==================\n');

      // First authenticate with Firebase
      final UserCredential firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If Firebase auth successful, authenticate with backend
      final response = await _dio.post(
        '$baseUrl/signin',
        data: {
          'email': email,  
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
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('Sign-out failed: $e');
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
