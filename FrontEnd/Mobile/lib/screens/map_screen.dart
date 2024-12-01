import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:map_flutter/screens/favorite.dart';
import 'notification.dart';
import 'sidemenu.dart';
import 'dart:ui';
import 'package:map_flutter/screens/profil_screen.dart';
import 'package:map_flutter/screens/transport/screens/select_transport_screen.dart';

const mapboxAccessToken =
    'pk.eyJ1Ijoic2ltb2FpdGVsZ2F6emFyIiwiYSI6ImNtMzVzeXYyazA2bWkybHMzb2Fxb3p6aGIifQ.ORYyvkZ2Z1H8WmouDkXtvQ';

final myPosition = LatLng(40.416775, -3.703790);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentPosition;
  bool _tracking = false;
  List<LatLng> _route = [];
  bool _isMenuOpen = false;
  bool _showAddressForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(myPosition, 15);
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_currentPosition!, 15);
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$mapboxAccessToken',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['features'].isNotEmpty) {
        final location = data['features'][0]['center'];
        final latitude = location[1];
        final longitude = location[0];

        // Recentrer la carte
        _mapController.move(LatLng(latitude, longitude), 15);

        setState(() {
          _tracking = true;
        });

        // Obtenez l'itinéraire entre la position actuelle et l'emplacement recherché
        _getRoute(LatLng(latitude, longitude));
      }
    }
  }

  // Fonction pour obtenir l'itinéraire entre la position actuelle et l'emplacement recherché
  Future<void> _getRoute(LatLng destination) async {
    if (_currentPosition == null) return;

    final url = Uri.parse(
      'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentPosition!.longitude},${_currentPosition!.latitude};${destination.longitude},${destination.latitude}.json?access_token=$mapboxAccessToken&alternatives=false&geometries=geojson',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0]['geometry']['coordinates'];
        List<LatLng> routePoints =
            route.map<LatLng>((point) => LatLng(point[1], point[0])).toList();

        setState(() {
          _route = routePoints;
        });

        // Calculer le centre de l'itinéraire
        double latSum = 0;
        double lonSum = 0;
        for (var point in routePoints) {
          latSum += point.latitude;
          lonSum += point.longitude;
        }

        // Calculer le centre moyen
        LatLng center =
            LatLng(latSum / routePoints.length, lonSum / routePoints.length);

        // Mettre à jour la carte pour centrer le trajet
        _mapController.move(center, 14); // Ajuster le niveau de zoom ici (14)
      }
    }
  }

  // Fonction pour gérer le clic sur la carte et créer l'itinéraire
  void _onMapTapped(LatLng latLng) {
    if (_currentPosition != null) {
      _getRoute(latLng); // Calculer l'itinéraire
      setState(() {
        _tracking = true; // Activer le suivi
      });
    }
  }

  // Fonction pour arrêter le suivi de localisation
  void _stopTracking() {
    setState(() {
      _tracking = false;
    });
  }

  void _showLocationConfirmation() {
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
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current location',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
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
                          '1901 Thornridge Cir. Shiloh, Hawaii 81063',
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
                        builder: (context) => const SelectTransportScreen(),
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

  // Modifier les gestionnaires d'événements dans _showAddressSelector
  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 570,
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
          children: [
            // Barre horizontale en haut
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
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
            // Champ From
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.my_location_outlined, color: Colors.grey[400]),
                  hintText: 'From',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.pop(context);
                    _showLocationConfirmation();
                  }
                },
              ),
            ),
            // Champ To
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey[400]),
                  hintText: 'To',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.pop(context);
                    _showLocationConfirmation();
                  }
                },
              ),
            ),
            // Recent places title
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 24.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent places',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            // Liste des lieux récents
            _buildRecentPlace('Office', '2.7km', 'Old Town Road 1234'),
            _buildRecentPlace('Coffee shop', '1.8km', 'New Street 5678'),
            _buildRecentPlace('Shopping center', '4.9km', 'Market Square 910'),
            _buildRecentPlace('Shopping mall', '4.5km', 'Mall Avenue 1112'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPlace(String title, String distance, String address) {
    return ListTile(
      leading: const Icon(Icons.location_on_outlined, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        address,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Text(
        distance,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _showLocationConfirmation();
      },
    );
  }

  Widget _buildMainContainer() {
    return Container(
      width: 364,
      height: 141,
      decoration: ShapeDecoration(
        color: Color(0xFFB9E5D1),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFF08B783)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bouton Rental - Ajusté pour s'aligner avec le container principal
          Positioned(
            top: -70,
            left: 0,
            child: Container(
              width: 172,
              height: 54,
              padding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 15.50),
              decoration: ShapeDecoration(
                color: Color(0xFF008955),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'Rental',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Bouton de localisation à droite
          Positioned(
            top: -70,
            right: 1,
            child: Container(
              width: 54,
              height: 54,
              decoration: ShapeDecoration(
                color: Color(0xFF008955),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.my_location, color: Colors.white),
                onPressed: () {
                  _getCurrentLocation();
                },
              ),
            ),
          ),
          // Contenu principal
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 336,
                height: 54,
                decoration: ShapeDecoration(
                  color: Color(0xFFE2F5ED),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF8AD4B5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.search, color: Color(0xFFA0A0A0)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Where would you go?',
                          hintStyle: TextStyle(
                            color: Color(0xFFA0A0A0),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                        onTap: _showAddressSelector,
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.favorite_border, color: Color(0xFFA0A0A0)),
                      onPressed: () {
                        // Ajoutez ici la logique pour les favoris
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 168,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Color(0xFF008955),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Transport',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 168,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: Color(0xFFE2F5ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Delivery',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.only(
                        top: 2, left: 2, right: 3, bottom: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(3.14),
                          child:
                              Container(width: 19, height: 19, child: Stack()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF08B783),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.account_balance_wallet, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          'Wallet',
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 25,
              onTap: (_, latLng) {
                _onMapTapped(latLng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': mapboxAccessToken,
                  'id': 'mapbox/streets-v11',
                },
              ),
              if (_route.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _route,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      width: 30.0,
                      height: 30.0,
                      child: Icon(
                        Icons.location_on,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 160,
            left: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildMainContainer(),
                Positioned(
                  top:
                      -70, // Ajusté pour éloigner le container "Rental" du rectangle principal
                  left: 1, // Aligné à droite avec le rectangle principal
                  child: Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15.50),
                    decoration: ShapeDecoration(
                      color: Color(0xFF008955),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Center(
                      child: Text(
                        'Rental',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuItem(Icons.home, 'Home', Color(0xFF08B783), () {}),
                  _buildMenuItem(
                      Icons.favorite_border, 'Favourite', Color(0xFF414141), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                    );
                  }),
                  _buildWalletButton(),
                  _buildMenuItem(Icons.local_offer, 'Offer', Color(0xFF414141), () {}),
                  _buildMenuItem(Icons.person, 'Profile', Color(0xFF414141), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  }),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF08B783),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        _isMenuOpen = !_isMenuOpen;  // Toggle the menu state
                      });
                    },
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_none),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isMenuOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  color: Colors.black.withOpacity(0.02),
                ),
              ),
            ),
          if (_isMenuOpen)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SideMenu(),
            ),
        ],
      ),
    );
  }
}

