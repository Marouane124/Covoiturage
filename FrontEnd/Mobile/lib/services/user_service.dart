import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final String baseUrl = 'http://192.168.1.5:8080/api';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final token = await _getToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      print('\n=== Get Profile Request ===');
      print('Firebase UID: ${currentUser.uid}');
      print('Endpoint: $baseUrl/utilisateur/${currentUser.uid}');
      print('========================\n');

      final response = await Dio().get(
        '$baseUrl/utilisateur/${currentUser.uid}',
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('\n=== Profile Response ===');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('========================\n');

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        await _authService.signOut();
        throw Exception('Session expired. Please login again.');
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch profile');
    } catch (e) {
      print('\n=== Get Profile Error ===');
      print('Type: ${e.runtimeType}');
      print('Message: $e');
      print('========================\n');
      rethrow;
    }
  }

  Future<bool> updateUserProfile({
    String? username,
    String? phone,
    String? gender,
    String? city,
  }) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      final token = await _getToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      final Map<String, dynamic> updateData = {
        if (username != null) 'username': username,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (city != null) 'city': city,
      };

      final response = await Dio().put(
        '$baseUrl/utilisateur/${currentUser.uid}',
        data: updateData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 401) {
        await _authService.signOut();
        throw Exception('Session expired. Please login again.');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('\n=== Update Profile Error ===');
      print('Type: ${e.runtimeType}');
      print('Message: $e');
      print('========================\n');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      // Clear stored tokens
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      // Sign out from backend if needed
      await _authService.signOut();
    } catch (e) {
      print('\n=== Sign Out Error ===');
      print('Type: ${e.runtimeType}');
      print('Message: $e');
      print('========================\n');
      rethrow;
    }
  }
}