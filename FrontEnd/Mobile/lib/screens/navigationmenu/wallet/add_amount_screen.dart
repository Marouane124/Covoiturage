import 'package:flutter/material.dart';
import 'package:map_flutter/screens/payment/thanks_screen.dart';

class AddAmountScreen extends StatefulWidget {
  const AddAmountScreen({super.key});

  @override
  State<AddAmountScreen> createState() => _AddAmountScreenState();
}

class _AddAmountScreenState extends State<AddAmountScreen> {
  int selectedTip = 1; // Default $2 tip selected
  final tipAmounts = [1, 2, 5, 10, 20];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            const Text(
              'Add Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Tip Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(
                tipAmounts.length,
                (index) => ChoiceChip(
                  label: Text('\$${tipAmounts[index]}'),
                  selected: selectedTip == tipAmounts[index],
                  onSelected: (isSelected) {
                    setState(() {
                      selectedTip = tipAmounts[index];
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThankYouScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008955),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
