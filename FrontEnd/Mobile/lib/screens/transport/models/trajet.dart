import 'package:intl/intl.dart';

class Trajet {
  final String conducteurId;
  final String villeDepart;
  final String villeArrivee;
  final DateTime date;
  final String heure;
  final int placesDisponibles;
  final double prix;
  final String voiture;
  final DateTime timestamp;

  Trajet({
    required this.conducteurId,
    required this.villeDepart,
    required this.villeArrivee,
    required this.date,
    required this.heure,
    required this.placesDisponibles,
    required this.prix,
    required this.voiture,
    required this.timestamp,
  });

  factory Trajet.fromJson(Map<String, dynamic> json) {
    return Trajet(
      conducteurId: json['conducteurId'] ?? '',
      villeDepart: json['villeDepart'] ?? '',
      villeArrivee: json['villeArrivee'] ?? '',
      date: DateFormat('dd/MM/yyyy')
          .parse(json['date'] ?? DateTime.now().toIso8601String()),
      heure: json['heure'] ?? '',
      placesDisponibles: json['placesDisponibles'] ?? 0,
      prix: (json['prix'] ?? 0.0).toDouble(),
      voiture: json['voiture'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conducteurId': conducteurId,
      'villeDepart': villeDepart,
      'villeArrivee': villeArrivee,
      'date': DateFormat('dd/MM/yyyy').format(date),
      'heure': heure,
      'placesDisponibles': placesDisponibles,
      'prix': prix,
      'voiture': voiture,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
