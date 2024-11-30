import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://192.168.1.161:8080/api';

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required List<String> roles,
  }) async {
    final url = '$baseUrl/signup';
    try {
      _dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final data = {
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
        'gender': gender,
        'roles': roles,
      };

      final response = await _dio.post(url, data: data);

      print('Sign-up successful: ${response.data}');
    } catch (e) {
      print('Error: $e');
      throw Exception('Sign-up failed: $e');
    }
  }

  // Login method
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = '$baseUrl/signin';
    try {
      _dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final data = {
        'username': username,
        'password': password,
      };

      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        return response.data; // Contains JWT and user details
      } else {
        throw Exception('Login failed: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Login failed: $e');
    }
  }
}
