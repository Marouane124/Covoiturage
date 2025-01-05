class Trajet {
  final String nomConducteur;
  final String villeDepart;
  final String villeArrivee;
  final String date;
  final String heure;
  final int placesDisponibles;
  final double prix;
  final String voiture;
  final String? photoUrl;

  Trajet({
    required this.nomConducteur,
    required this.villeDepart,
    required this.villeArrivee,
    required this.date,
    required this.heure,
    required this.placesDisponibles,
    required this.prix,
    required this.voiture,
    this.photoUrl,
  });

  factory Trajet.fromJson(Map<String, dynamic> json) {
    return Trajet(
      nomConducteur: json['nomConducteur'],
      villeDepart: json['villeDepart'],
      villeArrivee: json['villeArrivee'],
      date: json['date'],
      heure: json['heure'],
      placesDisponibles: json['placesDisponibles'],
      prix: json['prix'].toDouble(),
      voiture: json['voiture'],
      photoUrl: json['photoUrl'],
    );
  }
}