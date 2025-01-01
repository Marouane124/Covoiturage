class Trajet {
  final String nomConducteur;
  final String villeDepart;
  final String villeArrivee;
  final String date;
  final String heure;
  final int placesDisponibles;
  final double prix;
  final String voiture;

  Trajet({
    required this.nomConducteur,
    required this.villeDepart,
    required this.villeArrivee,
    required this.date,
    required this.heure,
    required this.placesDisponibles,
    required this.prix,
    required this.voiture,
  });

  factory Trajet.fromJson(Map<String, dynamic> json) {
    // Utiliser la méthode trim() pour nettoyer les chaînes
    return Trajet(
      nomConducteur: (json['nomConducteur'] ?? '').trim(),
      villeDepart: (json['villeDepart'] ?? '').trim(),
      villeArrivee: (json['villeArrivee'] ?? '').trim(),
      date: (json['date'] ?? '').trim(),
      heure: (json['heure'] ?? '').trim(),
      placesDisponibles: json['placesDisponibles'] ?? 0,
      prix: (json['prix'] ?? 0).toDouble(),
      voiture: (json['voiture'] ?? '').trim(),
    );
  }
}