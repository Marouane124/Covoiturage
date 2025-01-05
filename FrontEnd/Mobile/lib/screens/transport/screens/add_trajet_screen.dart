import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_flutter/config/app_config.dart';
import 'package:map_flutter/screens/transport/models/trajet.dart';
import 'package:map_flutter/screens/transport/screens/select_drivers_screen.dart';
import 'package:map_flutter/services/trajet_service.dart';

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
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF008955),
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF008955),
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        print("Date sélectionnée: $picked"); // Pour le débogage
        setState(() {
          _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection de la date: $e"); // Pour le débogage
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF008955),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Format avec les zéros pour les minutes < 10
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _heureController.text = "$hour:$minute";
      });
    }
  }

  Future<void> _submitTrajet() async {
    // Get the current user's ID from Firebase
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case where the user is not logged in
      print('No user is currently logged in.');
      return;
    }

    // Parse the date using DateFormat
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SelectDriversScreen()),
      );
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error adding trajet: $e');
    }
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
              TextFormField(
                controller: _villeDepartController,
                decoration: const InputDecoration(
                  labelText: 'Point de départ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ce champ est requis' : null,
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
    // Initialiser la date avec la date actuelle
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
