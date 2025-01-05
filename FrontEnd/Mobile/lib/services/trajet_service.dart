import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map_flutter/screens/transport/models/trajet.dart';
import '../config/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TrajetService {
  final String baseUrl = '${AppConfig.baseUrl}/trajets';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        List<Trajet> trajets =
            jsonList.map((json) => Trajet.fromJson(json)).toList();

        // Sort trajets from most recent to oldest based on timestamp
        trajets.sort((a, b) => b.timestamp.compareTo(
            a.timestamp)); // Assuming 'timestamp' is a DateTime object

        return trajets;
      } else {
        throw Exception('Failed to load trajets');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addTrajet(Trajet trajet) async {
    try {
      // Log the fields being sent
      print('Adding Trajet:');
      print('Conducteur ID: ${trajet.conducteurId}');
      print('Ville Depart: ${trajet.villeDepart}');
      print('Ville Arrivee: ${trajet.villeArrivee}');
      print('Date: ${DateFormat('dd/MM/yyyy').format(trajet.date)}');
      print('Heure: ${trajet.heure}');
      print('Places Disponibles: ${trajet.placesDisponibles}');
      print('Prix: ${trajet.prix}');
      print('Voiture: ${trajet.voiture}');
      print('Timestamp: ${trajet.timestamp.toIso8601String()}');

      // API call to add trajet
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'conducteurId': trajet.conducteurId,
          'villeDepart': trajet.villeDepart,
          'villeArrivee': trajet.villeArrivee,
          'date': DateFormat('dd/MM/yyyy').format(trajet.date),
          'heure': trajet.heure,
          'placesDisponibles': trajet.placesDisponibles,
          'prix': trajet.prix,
          'voiture': trajet.voiture,
          'timestamp': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
              .format(trajet.timestamp),
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add trajet');
      }
    } catch (e) {
      print('Error adding trajet: $e');
      throw e; // Rethrow the error for handling in the UI
    }
  }
}
