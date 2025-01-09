import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_flutter/screens/transport/models/trajet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:map_flutter/config/mapbox_config.dart';

class ConfirmTrajetScreen extends StatefulWidget {
  final Trajet trajet;
  final LatLng startLocation;
  final LatLng endLocation;

  const ConfirmTrajetScreen({
    Key? key,
    required this.trajet,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  @override
  _ConfirmTrajetScreenState createState() => _ConfirmTrajetScreenState();
}

class _ConfirmTrajetScreenState extends State<ConfirmTrajetScreen> {
  List<LatLng> routePoints = [];
  double distance = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    final url = MapboxConfig.getDirectionsUrl(
      widget.startLocation.longitude,
      widget.startLocation.latitude,
      widget.endLocation.longitude,
      widget.endLocation.latitude,
    );

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final geometry = route['geometry'];
        final coordinates = geometry['coordinates'] as List;

        setState(() {
          routePoints = coordinates
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();
          distance = route['distance'] / 1000; // Convertir en kilomètres
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du calcul de l\'itinéraire: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmer le trajet'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: widget.startLocation,
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: {
                        'accessToken': MapboxConfig.accessToken,
                        'id': MapboxConfig.mapId,
                      },
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4.0,
                          color: const Color(0xFF08B783),
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: widget.startLocation,
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF08B783),
                            size: 40.0,
                          ),
                          width: 40.0,
                          height: 40.0,
                        ),
                        Marker(
                          point: widget.endLocation,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0,
                          ),
                          width: 40.0,
                          height: 40.0,
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF08B783)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'De: ${widget.trajet.villeDepart}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'À: ${widget.trajet.villeArrivee}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Distance: ${distance.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Prix: ${widget.trajet.prix} DH',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF08B783),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Confirmer la localisation',
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
              ],
            ),
    );
  }
}
