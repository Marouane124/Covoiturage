import 'package:flutter/material.dart';
import 'package:map_flutter/screens/map_screen.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int selectedIndex = 0;

  Widget _buildHistoryItem(String name, String carModel, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  carModel,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Poppins',
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          ),
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0
                            ? const Color(0xFF2ECC71)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Upcoming',
                          style: TextStyle(
                            color: selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedIndex == 1
                            ? const Color(0xFF2ECC71)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            color: selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedIndex == 2
                            ? const Color(0xFF2ECC71)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Cancelled',
                          style: TextStyle(
                            color: selectedIndex == 2
                                ? Colors.white
                                : Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildHistoryItem('Nate', 'Mustang Shelby GT', 'Today at 09:20 am'),
                _buildHistoryItem('Henry', 'Mustang Shelby GT', 'Today at 10:20 am'),
                _buildHistoryItem('William', 'Mustang Shelby GT', 'Tomorrow at 09:20 am'),
                _buildHistoryItem('Nate', 'Mustang Shelby GT', 'Today at 09:20 am'),
                _buildHistoryItem('Henry', 'Mustang Shelby GT', 'Today at 10:20 am'),
                _buildHistoryItem('William', 'Mustang Shelby GT', 'Tomorrow at 09:20 am'),
                _buildHistoryItem('Henry', 'Mustang Shelby GT', 'Today at 10:20 am'),
                _buildHistoryItem('William', 'Mustang Shelby GT', 'Tomorrow at 09:20 am'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
