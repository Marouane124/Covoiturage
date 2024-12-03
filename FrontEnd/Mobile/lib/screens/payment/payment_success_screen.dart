import 'package:flutter/material.dart';
import 'review_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 361,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
              SizedBox(height: 16),
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
              SizedBox(height: 36),
              Text(
                'Payment Success',
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your money has been successfully sent to\nSergio Ramasis',
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
                '\$220',
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 34,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 24),
              Divider(color: Color(0xFFB8B8B8)),
              SizedBox(height: 16),
              Text(
                'How is your trip?',
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your feedback will help us to improve your\ndriving experience better',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close payment success dialog
                    showDialog(
                      context: context,
                      builder: (context) => ReviewScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF008955),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Please Feedback',
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
      ),
    );
  }
} 