import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:map_flutter/config/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverMode extends StatefulWidget {
  const DriverMode({super.key});

  @override
  _DriverModeState createState() => _DriverModeState();
}

class _DriverModeState extends State<DriverMode> {
  bool isDriverMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fonction pour obtenir l'uid de l'utilisateur connecté
  String? _getCurrentUserId() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }
    return user.uid;
  }

  // Fonction pour obtenir le rôle actuel
  Future<void> getCurrentRole() async {
    try {
      final String uid = _getCurrentUserId()!;
      
      print('UID de l\'utilisateur: $uid'); // Debug log

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/utilisateur/$uid/role'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isDriverMode = data['roles']['conducteur'] ?? false;
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur complète: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Se connecter',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      );
    }
  }

  // Fonction pour changer le rôle
  Future<void> toggleUserRole() async {
    try {
      final String uid = _getCurrentUserId()!;

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/utilisateur/$uid/toggleRole'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isDriverMode = !isDriverMode;
        });
        
        // Reformuler le message pour qu'il soit plus clair
        String role = isDriverMode ? 'CONDUCTEUR' : 'PASSAGER';
        String message = 'Rôle changé avec succès en $role.';
        
        // Afficher une boîte de dialogue avec le message
        _showAlertDialog(message);
      } else {
        throw Exception('Échec du changement de rôle');
      }
    } catch (e) {
      // Afficher une boîte de dialogue d'erreur
      _showAlertDialog('Une erreur est survenue lors du changement de rôle.');
      // Remettre le switch dans son état précédent en cas d'erreur
      setState(() {
        isDriverMode = !isDriverMode;
      });
    }
  }

  // Fonction pour afficher une boîte de dialogue
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Information',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Driver Mode',
          style: TextStyle(
            color: Color(0xFF2A2A2A),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Driver Mode',
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Mode Conducteur',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: isDriverMode,
                  onChanged: (bool value) async {
                    await toggleUserRole();
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isDriverMode
                    ? 'Vous êtes en mode conducteur.'
                    : 'Vous êtes en mode passager.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}