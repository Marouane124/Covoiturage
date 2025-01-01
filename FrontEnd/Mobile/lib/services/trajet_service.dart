import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map_flutter/screens/transport/models/trajet.dart';
import '../config/app_config.dart';

class TrajetService {
  final String baseUrl = '${AppConfig.baseUrl}/trajets';

  Future<List<Trajet>> getAllTrajets() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Trajet.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trajets');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}