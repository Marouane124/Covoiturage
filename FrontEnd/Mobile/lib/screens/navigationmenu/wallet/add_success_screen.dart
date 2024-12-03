import 'package:flutter/material.dart';

class AddSuccessScreen extends StatelessWidget {
  final double amount;
  const AddSuccessScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Container(
        width: 361,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Color(0xFF5A5A5A)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE2F5ED),
              ),
              child: Icon(
                Icons.check_circle,
                size: 86,
                color: Color(0xFF08B783),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Add Success',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your money has been add successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF898989),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Amount',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 34,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008955),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Back Home',
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
} 