import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:map_flutter/config/app_config.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/screens/transport/models/trajet.dart';
import 'package:map_flutter/screens/transport/screens/select_drivers_screen.dart';
import 'package:map_flutter/services/trajet_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class AddTrajetScreen extends StatefulWidget {
  const AddTrajetScreen({Key? key}) : super(key: key);

  @override
  _AddTrajetScreenState createState() => _AddTrajetScreenState();
}

class _AddTrajetScreenState extends State<AddTrajetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TrajetService _trajetService = TrajetService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _villeDepartController = TextEditingController();
  final TextEditingController _villeArriveeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heureController = TextEditingController();
  final TextEditingController _placesController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _voitureController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    try {
      DateTime firstDate = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025, 12, 31),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF08B783),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      ).then((selectedDate) {
        if (selectedDate != null) {
          if (selectedDate.isBefore(firstDate)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Veuillez sélectionner une date future'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            setState(() {
              _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
            });
          }
        }
      });
    } catch (e) {
      print("Erreur lors de la sélection de la date: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de la date: $e')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextColor: Colors.black, // Pour l'heure et les minutes
              helpTextStyle: TextStyle(color: Colors.black, fontSize: 16), // Pour "Sélectionner une heure"
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF08B783), // Couleur principale
              onPrimary: Colors.white, // Texte sur le bouton principal
              surface: Colors.white, // Fond des boutons
              onSurface: Colors.black, // Couleur des autres textes
            ),
            dialogBackgroundColor: Colors.white, // Couleur du fond du dialogue
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _heureController.text = "$hour:$minute";
      });
    }
  }

  Future<void> _submitTrajet() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('No user is currently logged in.');
      return;
    }

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
    } catch (e) {
      print('Error parsing date: $e');
      return;
    }

    final trajet = Trajet(
      conducteurId: currentUser.uid,
      villeDepart: _villeDepartController.text,
      villeArrivee: _villeArriveeController.text,
      date: parsedDate,
      heure: _heureController.text,
      placesDisponibles: int.parse(_placesController.text),
      prix: double.parse(_prixController.text),
      voiture: _voitureController.text,
      timestamp: DateTime.now(),
    );

    try {
      await _trajetService.addTrajet(trajet);
      print('Trajet added successfully!');

      // Afficher une alerte
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le trajet a été ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      // Rediriger vers la page de confirmation de localisation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapScreen()), // Remplacez par la page de confirmation si nécessaire
      );
    } catch (e) {
      print('Error adding trajet: $e');
    }
  }

  void showLocationConfirmation(LatLng currentLocation, String destination) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Current Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current location',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '40, 3, Jl. Marrakesh, Marrakesh-Sa', // Adresse actuelle
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Office Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF08B783)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Office',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          destination,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '1.1km',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectDriversScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008955),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Trajet'),
        backgroundColor: const Color(0xFF008955),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _villeDepartController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Point de départ',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                ),
                readOnly: true,  // Rendre le champ en lecture seule
                enabled: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _villeArriveeController,
                decoration: const InputDecoration(
                  labelText: 'Point d\'arrivée',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                        color: const Color(0xFF008955),
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'La date est requise' : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heureController,
                decoration: InputDecoration(
                  labelText: 'Heure',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                readOnly: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placesController,
                decoration: const InputDecoration(
                  labelText: 'Places disponibles',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prixController,
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _voitureController,
                decoration: const InputDecoration(
                  labelText: 'Voiture',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitTrajet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008955),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Ajouter le trajet',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<void> _getCurrentLocation() async {
    final Location location = Location();

    try {
      final LocationData locationData = await location.getLocation();
      final coordinates = LatLng(locationData.latitude!, locationData.longitude!);

      // Obtenir l'adresse à partir des coordonnées
      final address = await _getAddressFromCoordinates(coordinates);

      setState(() {
        _villeDepartController.text = address;
      });
    } catch (e) {
      print('Erreur lors de la récupération de la localisation: $e');
    }
  }

  Future<String> _getAddressFromCoordinates(LatLng coordinates) async {
    final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json?access_token=$mapboxAccessToken&language=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          // Extraire uniquement le nom de la rue et la ville
          final place = data['features'][0];
          final address = place['place_name_fr'] ?? place['place_name'];
          return address.split(',').take(2).join(', ').trim();
        }
      }
      return 'Adresse non trouvée';
    } catch (e) {
      print('Erreur lors de la récupération de l\'adresse: $e');
      return 'Erreur de localisation';
    }
  }

  @override
  void dispose() {
    _villeDepartController.dispose();
    _villeArriveeController.dispose();
    _dateController.dispose();
    _heureController.dispose();
    _placesController.dispose();
    _prixController.dispose();
    _voitureController.dispose();
    super.dispose();
  }
}
