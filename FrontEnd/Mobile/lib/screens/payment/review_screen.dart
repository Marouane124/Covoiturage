import 'package:flutter/material.dart';
import 'thanks_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int selectedTip = 1; // Default $2 tip selected
  final tipAmounts = [1, 2, 5, 10, 20];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: Color(0xFF00AA6D),
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Excellent',
              style: TextStyle(
                color: Color(0xFF00AA6D),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'You rated Sergio Ramasis 4 star',
              style: TextStyle(
                color: Color(0xFFB8B8B8),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your text',
                hintStyle: TextStyle(
                  color: Color(0xFFD0D0D0),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFB8B8B8)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Give some tips to Sergio Ramasis',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: tipAmounts.map((amount) => _buildTipButton(amount)).toList(),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle custom amount
              },
              child: Text(
                'Enter other amount',
                style: TextStyle(
                  color: Color(0xFF08B783),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close review dialog
                  showDialog(
                    context: context,
                    builder: (context) => ThankYouScreen(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008955),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
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
      width: 134,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        color: Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  Widget _buildTipButton(int amount) {
    final isSelected = amount == tipAmounts[selectedTip];
    return GestureDetector(
      onTap: () => setState(() => selectedTip = tipAmounts.indexOf(amount)),
      child: Container(
        width: 55,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Color(0xFF08B783) : Color(0xFFDDDDDD),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            '\$$amount',
            style: TextStyle(
              color: isSelected ? Color(0xFF08B783) : Color(0xFF5A5A5A),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
} 