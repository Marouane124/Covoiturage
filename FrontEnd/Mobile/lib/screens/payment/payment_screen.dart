import 'package:flutter/material.dart';
import '../../models/payment_method.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPaymentMethod = 0; // Track the selected payment method

  // Define payment methods data
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              _buildCarDetailsCard(),
              _buildChargeSection(),
              _buildPaymentMethods(),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Color(0xFF414141)),
                SizedBox(width: 8),
                Text(
                  'Back',
                  style: TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              'Payment',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 48), // To balance the back button
        ],
      ),
    );
  }

  Widget _buildCarDetailsCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFE2F5ED),
          border: Border.all(color: Color(0xFF08B783)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mustang Shelby GT',
                    style: TextStyle(
                      color: Color(0xFF5A5A5A),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '4.9 (531 reviews)',
                    style: TextStyle(
                      color: Color(0xFFB8B8B8),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 93,
              height: 54,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/93x54"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChargeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Charge',
            style: TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          _buildChargeRow('Mustang/per hours', '\$200'),
          SizedBox(height: 8),
          _buildChargeRow('Vat (5%)', '\$20'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Color(0xFFE8E8E8)),
          ),
          _buildChargeRow('Total', '\$220', isBold: true),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF5A5A5A),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: Color(0xFF5A5A5A),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select payment method',
            style: TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
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

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => PaymentSuccessScreen(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF008955),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Confirm Ride',
            style: TextStyle(
              color: Colors.white,
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
