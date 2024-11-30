import 'package:flutter/material.dart';
import 'package:map_flutter/screens/transport/screens/available_vehicles_screen.dart';
import '../../../generated/l10n.dart';

class SelectTransportScreen extends StatelessWidget {
  const SelectTransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TransportOption> transportOptions = [
      TransportOption(
        imageUrl: 'https://www.svgrepo.com/show/61015/car.svg',
        label: S.of(context).car,
      ),
      TransportOption(
        imageUrl: 'https://www.svgrepo.com/show/61064/motorcycle.svg',
        label: S.of(context).bike,
      ),
      TransportOption(
        imageUrl: 'https://www.svgrepo.com/show/61072/bicycle.svg',
        label: S.of(context).cycle,
      ),
      TransportOption(
        imageUrl: 'https://www.svgrepo.com/show/61084/taxi.svg',
        label: S.of(context).taxi,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).select_transport,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).select_your_transport,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: transportOptions.length,
              itemBuilder: (context, index) {
                return TransportCard(
                  imageUrl: transportOptions[index].imageUrl,
                  label: transportOptions[index].label,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailableVehiclesScreen(
                          transportType: transportOptions[index].label,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransportOption {
  final String imageUrl;
  final String label;

  TransportOption({
    required this.imageUrl,
    required this.label,
  });
}

class TransportCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const TransportCard({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: 50,
              width: 50,
              color: const Color(0xFF008955),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF008955),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
