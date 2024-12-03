import 'package:flutter/material.dart';
import 'add_success_screen.dart';

class AddAmountScreen extends StatefulWidget {
  const AddAmountScreen({super.key});

  @override
  State<AddAmountScreen> createState() => _AddAmountScreenState();
}

class _AddAmountScreenState extends State<AddAmountScreen> {
  int selectedPaymentMethod = 0;
  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      cardNumber: '**** **** **** 8970',
      expiryDate: '12/26',
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      cardNumber: '**** **** **** 8970',
      expiryDate: '12/26',
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      cardNumber: 'mailaddress@mail.com',
      expiryDate: '12/26',
      icon: Icons.payment,
    ),
    PaymentMethod(
      cardNumber: 'Cash',
      expiryDate: '12/26',
      icon: Icons.money,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF414141)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Amount',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Amount',
                hintStyle: TextStyle(
                  color: Color(0xFFD0D0D0),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFB8B8B8)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle add payment method
                },
                child: Text(
                  'Add payment Method',
                  style: TextStyle(
                    color: Color(0xFF304FFE),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Payment Method',
              style: TextStyle(
                color: Color(0xFF414141),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            ...List.generate(
              paymentMethods.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = index;
                    });
                  },
                  child: _buildPaymentMethodCard(
                    isActive: selectedPaymentMethod == index,
                    paymentMethod: paymentMethods[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close add amount screen
              showDialog(
                context: context,
                builder: (context) => AddSuccessScreen(amount: 220.00), // Pass the actual amount
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF008955),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Confirm',
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
    );
  }

  Widget _buildPaymentMethodCard({
    required bool isActive,
    required PaymentMethod paymentMethod,
  }) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.4,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFE2F5ED),
          border: Border.all(color: Color(0xFF08B783)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(paymentMethod.icon, size: 35, color: Color(0xFF08B783)),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentMethod.cardNumber,
                  style: TextStyle(
                    color: Color(0xFF5A5A5A),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Expires: ${paymentMethod.expiryDate}',
                  style: TextStyle(
                    color: Color(0xFFB8B8B8),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String cardNumber;
  final String expiryDate;
  final IconData icon;

  PaymentMethod({
    required this.cardNumber,
    required this.expiryDate,
    required this.icon,
  });
} 