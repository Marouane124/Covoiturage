import 'package:dio/dio.dart';
import '../config/app_config.dart';

class PaymentService {
  final Dio _dio = Dio();
  final String baseUrl = '${AppConfig.baseUrl}/paiements';

  // Fetch all payments
  Future<List<dynamic>> getAllPayments() async {
    try {
      final response = await _dio.get('$baseUrl');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch payments');
      }
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }

  // Update an existing payment
  Future<Map<String, dynamic>> updatePayment(
      String id, Map<String, dynamic> paymentData) async {
    try {
      final response = await _dio.put(
        '$baseUrl/$id',
        data: paymentData,
      );
      if (response.statusCode == 200) {
        return response.data;  // Ensure the backend returns the updated payment
      } else {
        throw Exception('Failed to update payment');
      }
    } catch (e) {
      throw Exception('Error updating payment: $e');
    }
  }

  // Create a new payment
  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> paymentData) async {
    try {
      // Making the POST request
      final response = await _dio.post(
        baseUrl,
        data: paymentData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! >= 200 && status < 300,
        ),
      );

      // Check if the response is successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Payment created successfully: ${response.data}");
        return response.data; // Return the response data
      } else {
        print("Failed to create payment. Status code: ${response.statusCode}");
        throw Exception('Failed to create payment: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("DioError creating payment: ${e.message}");
      if (e.response != null) {
        print("Error response data: ${e.response?.data}");
        throw Exception('Server error: ${e.response?.data}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print("Error creating payment: $e");
      throw Exception('Error creating payment: $e');
    }
  }

  // Delete a payment
  Future<void> deletePayment(String id) async {
    try {
      final response = await _dio.delete('$baseUrl/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete payment');
      }
    } catch (e) {
      throw Exception('Error deleting payment: $e');
    }
  }
}
