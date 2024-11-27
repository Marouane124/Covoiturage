import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api',  // Change back to localhost since it works in Postman
    headers: {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    },
  ));

  Future<void> signup(String username, String email, String role, String password) async {
  try {
    print('Attempting to connect to: ${_dio.options.baseUrl}/signup');
    final response = await _dio.post(
      '/signup',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'role': [role],  // Send the role as a string array (as the backend expects a list of roles)
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } on DioException catch (e) {
    print('Connection failed:');
    print('URL: ${e.requestOptions.uri}');
    print('Error type: ${e.type}');
    print('Error message: ${e.message}');
    print('Response: ${e.response}');
    rethrow;
  }
}


}