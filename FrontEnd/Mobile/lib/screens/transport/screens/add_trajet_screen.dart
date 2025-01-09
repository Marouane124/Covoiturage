import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'package:map_flutter/config/app_config.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/screens/transport/models/trajet.dart';
import 'package:map_flutter/screens/transport/screens/select_drivers_screen.dart';
import 'package:map_flutter/services/trajet_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:map_flutter/screens/transport/screens/confirm_trajet_screen.dart';

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
  final MapController _mapController = MapController();

  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  List<LatLng> _routePoints = [];
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoadingSuggestions = false;
  bool _isLoadingRoute = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    final Location location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final LocationData locationData = await location.getLocation();
      final coordinates = LatLng(locationData.latitude!, locationData.longitude!);
      print('Position actuelle: ${coordinates.latitude}, ${coordinates.longitude}');

      // Obtenir l'adresse à partir des coordonnées
      final address = await _getAddressFromCoordinates(coordinates);

      setState(() {
        _currentPosition = coordinates;
        _villeDepartController.text = address;
      });
    } catch (e) {
      print('Erreur lors de la récupération de la localisation: $e');
    }
  }

  Future<void> _getSuggestions(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _suggestions = [];
          _isLoadingSuggestions = false;
        });
        return;
      }

      setState(() {
        _isLoadingSuggestions = true;
      });

      try {
        final url = Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json'
          '?access_token=$mapboxAccessToken'
          '&language=fr'
          '&limit=5'
        );

        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _suggestions = List<Map<String, dynamic>>.from(data['features'].map((feature) {
              return {
                'place_name': feature['place_name'],
                'coordinates': LatLng(
                  feature['geometry']['coordinates'][1],
                  feature['geometry']['coordinates'][0],
                ),
              };
            }));
            _isLoadingSuggestions = false;
          });
        }
      } catch (e) {
        print('Erreur lors de la récupération des suggestions: $e');
        setState(() {
          _isLoadingSuggestions = false;
          _suggestions = [];
        });
      }
    });
  }

  Future<String> _getAddressFromCoordinates(LatLng coordinates) async {
    final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json?access_token=$mapboxAccessToken&language=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'].isNotEmpty) {
          return data['features'][0]['place_name'];
        }
      }
      return '';
    } catch (e) {
      print('Erreur lors de la récupération de l\'adresse: $e');
      return '';
    }
  }

  Future<void> _getRoute() async {
    if (_currentPosition == null || _destinationPosition == null) {
      print('Position actuelle ou destination manquante');
      return;
    }

    print('Calcul de l\'itinéraire entre:');
    print('Départ: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
    print('Arrivée: ${_destinationPosition!.latitude}, ${_destinationPosition!.longitude}');

    setState(() {
      _isLoadingRoute = true;
    });

    try {
      final url = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${_currentPosition!.longitude},${_currentPosition!.latitude};'
        '${_destinationPosition!.longitude},${_destinationPosition!.latitude}'
        '?geometries=geojson&access_token=$mapboxAccessToken'
      );

      print('URL de l\'API: $url');

      final response = await http.get(url);
      print('Statut de la réponse: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates = data['routes'][0]['geometry']['coordinates'] as List;
          print('Nombre de points dans l\'itinéraire: ${coordinates.length}');
          
          setState(() {
            _routePoints = coordinates
                .map((coord) => LatLng(coord[1] as double, coord[0] as double))
                .toList();
            _isLoadingRoute = false;
          });

          print('Points de l\'itinéraire: $_routePoints');
          
          // Ajuster la vue de la carte pour montrer tout l'itinéraire
          _fitRoute();
        } else {
          print('Pas d\'itinéraire trouvé dans la réponse');
        }
      } else {
        print('Erreur de l\'API: ${response.body}');
      }
    } catch (e) {
      print('Erreur lors du calcul de l\'itinéraire: $e');
      setState(() {
        _isLoadingRoute = false;
      });
    }
  }

  void _fitRoute() {
    if (_routePoints.isEmpty) return;
    
    double minLat = _routePoints[0].latitude;
    double maxLat = _routePoints[0].latitude;
    double minLng = _routePoints[0].longitude;
    double maxLng = _routePoints[0].longitude;

    for (var point in _routePoints) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    // Calculer le centre de la zone
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    
    // Calculer le zoom approprié
    final latZoom = math.log(360 / (maxLat - minLat)) / math.ln2;
    final lngZoom = math.log(360 / (maxLng - minLng)) / math.ln2;
    final zoom = math.min(latZoom, lngZoom) - 1;

    _mapController.move(LatLng(centerLat, centerLng), zoom);
  }

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
        backgroundColor: const Color(0xFF08B783),
        title: const Text('Ajouter un Trajet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? const LatLng(33.5731, -7.5898),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxAccessToken',
                additionalOptions: const {
                  'accessToken': mapboxAccessToken,
                  'id': 'mapbox/streets-v11',
                },
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: const Color(0xFF08B783),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_currentPosition != null)
                    Marker(
                      point: _currentPosition!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF08B783),
                        size: 40,
                      ),
                    ),
                  if (_destinationPosition != null)
                    Marker(
                      point: _destinationPosition!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select address',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Point de départ
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(Icons.my_location, color: Color(0xFF08B783)),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _villeDepartController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: 'From',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Point d'arrivée
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: TextField(
                                  controller: _villeArriveeController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: 'To',
                                    hintText: 'Ville d\'arrivée',
                                    prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: _isLoadingSuggestions
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  onChanged: (value) {
                                    _getSuggestions(value);
                                  },
                                ),
                              ),
                              if (_suggestions.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _suggestions.length,
                                    itemBuilder: (context, index) {
                                      final suggestion = _suggestions[index];
                                      return ListTile(
                                        title: Text(
                                          suggestion['place_name'],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            _villeArriveeController.text = suggestion['place_name'];
                                            _destinationPosition = suggestion['coordinates'];
                                            _suggestions = [];
                                          });
                                          await _getRoute();
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Date et Heure
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today, color: Color(0xFF08B783)),
                                        const SizedBox(width: 8),
                                        Text(
                                          _dateController.text,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectTime(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Color(0xFF08B783)),
                                        const SizedBox(width: 8),
                                        Text(
                                          _heureController.text.isEmpty ? 'Heure' : _heureController.text,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Places et Prix
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: TextField(
                                    controller: _placesController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: 'Places',
                                      prefixIcon: Icon(Icons.people, color: Color(0xFF08B783)),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: TextField(
                                    controller: _prixController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: 'Prix',
                                      prefixIcon: Icon(Icons.attach_money, color: Color(0xFF08B783)),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Voiture
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: _voitureController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Voiture',
                                prefixIcon: Icon(Icons.directions_car, color: Color(0xFF08B783)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Bouton Ajouter
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitTrajet,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF08B783),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Ajouter le trajet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
