import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_flutter/config/app_config.dart';
import 'package:http_parser/http_parser.dart';

class DriverService {
  final Dio _dio = Dio();
  final String baseUrl = AppConfig.baseUrl;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> registerDriver({
    required String licenseNumber,
    required String vehicleModel,
    required String vehicleYear,
    required String plateNumber,
    required File licenseFrontImage,
    required File licenseBackImage,
  }) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      var formData = FormData();

      formData.fields.addAll([
        MapEntry('uid', currentUser.uid), // Changed to match backend parameter
        MapEntry('licenseNumber', licenseNumber),
        MapEntry('vehicleModel', vehicleModel),
        MapEntry('vehicleYear', vehicleYear),
        MapEntry('plateNumber', plateNumber),
      ]);

      formData.files.addAll([
        MapEntry(
          'licenseFrontImage',
          await MultipartFile.fromFile(
            licenseFrontImage.path,
            filename: 'front_license.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
        MapEntry(
          'licenseBackImage',
          await MultipartFile.fromFile(
            licenseBackImage.path,
            filename: 'back_license.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      ]);

      print('\n=== Driver Registration Request ===');
      print('Firebase UID: ${currentUser.uid}');
      print('License Number: $licenseNumber');
      print('Vehicle Model: $vehicleModel');
      print('Vehicle Year: $vehicleYear');
      print('Plate Number: $plateNumber');
      print('========================\n');

      final response = await _dio.post(
        '$baseUrl/drivers/register',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
        ),
      );

      print('\n=== API Response ===');
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('==================\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _updateUserRole(currentUser.uid);
        return true;
      }

      throw Exception(response.data['message'] ?? 'Registration failed');
    } catch (e) {
      print('=== Driver Registration Error ===');
      print('Type: ${e.runtimeType}');
      print('Message: $e');
      print('========================');
      rethrow;
    }
  }

  Future<void> _updateUserRole(String userId) async {
    try {
      await _dio.put(
        '$baseUrl/users/$userId/role',
        data: {'role': 'DRIVER'},
      );
    } catch (e) {
      print('Failed to update user role: $e');
    }
  }
}
