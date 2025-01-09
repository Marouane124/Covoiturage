import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_flutter/screens/transport/screens/select_drivers_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:map_flutter/config/app_config.dart';
import 'package:geolocator/geolocator.dart';

class SearchTrajetScreen extends StatefulWidget {
  const SearchTrajetScreen({Key? key}) : super(key: key);

  @override
  _SearchTrajetScreenState createState() => _SearchTrajetScreenState();
}

class _SearchTrajetScreenState extends State<SearchTrajetScreen> {
  final TextEditingController _departController = TextEditingController();
  final TextEditingController _arriveeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heureController = TextEditingController();
  final TextEditingController _placesController = TextEditingController();
  
  List<String> _departSuggestions = [];
  List<String> _arriveeSuggestions = [];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final now = DateTime.now();
    _heureController.text = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _placesController.text = '1';
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      setState(() {
        _currentPosition = position;
      });
      await _getReverseGeocode(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _getReverseGeocode(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lon,$lat.json?access_token=${AppConfig.mapboxAccessToken}'
      );
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          setState(() {
            _departController.text = data['features'][0]['place_name'];
          });
        }
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  void _useCurrentLocation() async {
    if (_currentPosition != null) {
      await _getReverseGeocode(_currentPosition!.latitude, _currentPosition!.longitude);
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _getSuggestions(String query, bool isDepart) async {
    if (query.isEmpty) {
      setState(() {
        if (isDepart) {
          _departSuggestions = [];
        } else {
          _arriveeSuggestions = [];
        }
      });
      return;
    }

    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=${AppConfig.mapboxAccessToken}&country=ma',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final suggestions = List<String>.from(
          data['features'].map((feature) => feature['place_name'] as String),
        );
        setState(() {
          if (isDepart) {
            _departSuggestions = suggestions;
          } else {
            _arriveeSuggestions = suggestions;
          }
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des suggestions: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF08B783),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF08B783),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _heureController.text = selectedTime.format(context);
      });
    }
  }

  void _searchTrajet() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      Future.delayed(Duration(seconds: 1), () {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectDriversScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rechercher un Trajet',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Point de départ
              Text(
                'Point de départ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  TextFormField(
                    controller: _departController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Color(0xFF08B783)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location, color: Color(0xFF08B783)),
                        onPressed: _useCurrentLocation,
                      ),
                      hintText: 'D\'où partez-vous?',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF08B783)),
                      ),
                    ),
                    onChanged: (value) => _getSuggestions(value, true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un point de départ';
                      }
                      return null;
                    },
                  ),
                  if (_departSuggestions.isNotEmpty)
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: _departSuggestions.take(3).map((suggestion) {
                            return ListTile(
                              leading: Icon(Icons.location_on_outlined, color: Colors.grey),
                              title: Text(
                                suggestion,
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                setState(() {
                                  _departController.text = suggestion;
                                  _departSuggestions = [];
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Point d'arrivée
              Text(
                'Point d\'arrivée',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  TextFormField(
                    controller: _arriveeController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      hintText: 'Où allez-vous?',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF08B783)),
                      ),
                    ),
                    onChanged: (value) => _getSuggestions(value, false),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un point d\'arrivée';
                      }
                      return null;
                    },
                  ),
                  if (_arriveeSuggestions.isNotEmpty)
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: _arriveeSuggestions.take(3).map((suggestion) {
                            return ListTile(
                              leading: Icon(Icons.location_on_outlined, color: Colors.grey),
                              title: Text(
                                suggestion,
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                setState(() {
                                  _arriveeController.text = suggestion;
                                  _arriveeSuggestions = [];
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Date et Heure
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _dateController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF08B783)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF08B783)),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Heure',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _heureController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.access_time, color: Color(0xFF08B783)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF08B783)),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectTime(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Nombre de places
              Text(
                'Nombre de places',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _placesController,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.people, color: Color(0xFF08B783)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF08B783)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de places';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Entrez un nombre valide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Bouton de recherche
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _searchTrajet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B783),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Rechercher',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
