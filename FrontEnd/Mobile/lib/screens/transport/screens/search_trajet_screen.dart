import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_flutter/screens/transport/screens/select_drivers_screen.dart';

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12, 31),
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
    );

    if (selectedTime != null) {
      setState(() {
        _heureController.text = selectedTime.format(context);
      });
    }
  }

  void _searchTrajet() {
    String depart = _departController.text;
    String arrivee = _arriveeController.text;
    String date = _dateController.text;
    String heure = _heureController.text;
    String places = _placesController.text;

    // Logique de recherche ici
    print('Recherche de trajet de $depart à $arrivee le $date à $heure pour $places places');

    // Rediriger vers SelectDriversScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDriversScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher un Trajet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _departController,
              decoration: const InputDecoration(
                labelText: 'Point de départ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _arriveeController,
              decoration: const InputDecoration(
                labelText: 'Point d\'arrivée',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heureController,
              decoration: const InputDecoration(
                labelText: 'Heure',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _placesController,
              decoration: const InputDecoration(
                labelText: 'Nombre de places',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _searchTrajet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008955),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Rechercher',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
