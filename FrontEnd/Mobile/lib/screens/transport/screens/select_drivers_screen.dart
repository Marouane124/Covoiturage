import 'package:flutter/material.dart';
import '../../../services/trajet_service.dart';
import '../models/trajet.dart';
import 'dart:math';

class SelectDriversScreen extends StatefulWidget {
  @override
  _SelectDriversScreenState createState() => _SelectDriversScreenState();
}

class _SelectDriversScreenState extends State<SelectDriversScreen> {
  final TrajetService _trajetService = TrajetService();
  List<Trajet> _trajets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrajets();
  }

  Future<void> _loadTrajets() async {
    try {
      final trajets = await _trajetService.getAllTrajets();
      setState(() {
        _trajets = trajets;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading trajets: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available drivers for ride',
          style: TextStyle(color: Color(0xFF5A5A5A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_trajets.length} drivers found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _trajets.length,
                      itemBuilder: (context, index) {
                        final trajet = _trajets[index];
                        return _buildDriverCard(
                          driverName: trajet.nomConducteur,
                          seats: trajet.placesDisponibles.toString(),
                          carModel: trajet.voiture,
                          price: '${trajet.prix.toString()} DH',
                          distance: '${trajet.villeDepart} to ${trajet.villeArrivee}',
                          imageUrl: 'assets/me.jpeg',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDriverCard({
    required String driverName,
    required String seats,
    required String carModel,
    required String price,
    required String distance,
    required String imageUrl,
  }) {
    final randomDistance = Random().nextInt(1000) + 100;
    final randomTime = (randomDistance / 200).round();

    return Card(
      color: Color(0xFFE0F7FA),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver: $driverName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$carModel | $seats seats | $price',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    distance,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${randomDistance}m (${randomTime} mins away)',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Action pour voir la liste des voitures
                    },
                    child: Text(
                      'View driver list',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008955),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
