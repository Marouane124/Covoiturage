import 'package:flutter/material.dart';
import '../../../services/trajet_service.dart';
import '../../../services/user_service.dart';
import '../models/trajet.dart';
import 'dart:math';
import 'driver_details_screen.dart';
import 'package:map_flutter/screens/chat_page.dart';
import 'dart:typed_data';
import 'dart:convert'; // Import for base64 decoding

class SelectDriversScreen extends StatefulWidget {
  @override
  _SelectDriversScreenState createState() => _SelectDriversScreenState();
}

class _SelectDriversScreenState extends State<SelectDriversScreen> {
  final TrajetService _trajetService = TrajetService();
  final UserService _userService = UserService();
  List<Trajet> _trajets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrajets();
  }

  Future<void> _loadTrajets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _trajets = await _trajetService.getAllTrajets();
    } catch (e) {
      print('Error loading trajets: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshTrajets() async {
    await _loadTrajets();
  }

  Future<Map<String, String>> _getDriverInfo(String driverId) async {
    final profile = await _userService.getProfile(driverId);
    return {
      'name': profile['username'] ?? 'Unknown',
      'photoUrl': profile['profileImage'] ?? 'assets/default_profile.png',
      'email': profile['email'] ?? 'unknown@example.com',
    };
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
      body: RefreshIndicator(
        onRefresh: _refreshTrajets,
        child: _isLoading
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
                          return FutureBuilder<Map<String, String>>(
                            future: _getDriverInfo(trajet.conducteurId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListTile(title: Text('Loading...'));
                              } else if (snapshot.hasError) {
                                return ListTile(
                                    title: Text('Error: ${snapshot.error}'));
                              } else {
                                final driverInfo = snapshot.data!;
                                return _buildDriverCard(
                                  driverName: driverInfo['name']!,
                                  imageUrl: driverInfo['photoUrl']!,
                                  seats: trajet.placesDisponibles.toString(),
                                  carModel: trajet.voiture,
                                  price: '${trajet.prix.toString()} DH',
                                  distance:
                                      '${trajet.villeDepart} to ${trajet.villeArrivee}',
                                  onViewDriverList: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          receiverId: trajet.conducteurId,
                                          receiverEmail: driverInfo['email']!,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDriverCard({
    required String driverName,
    required String imageUrl,
    required String seats,
    required String carModel,
    required String price,
    required String distance,
    required VoidCallback onViewDriverList,
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
                    onPressed: onViewDriverList,
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
              child: _buildDriverImage(imageUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverImage(String imageUrl) {
    // Check if the imageUrl is a Base64 string
    if (imageUrl.startsWith('/9j/')) {
      // Check for Base64 image prefix
      // Decode the Base64 image
      Uint8List imageBytes = base64Decode(imageUrl);
      return Image.memory(
        imageBytes,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/default_profile.png'); // Fallback image
        },
      );
    } else {
      // Use the image URL directly
      return Image.network(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/default_profile.png'); // Fallback image
        },
      );
    }
  }
}
