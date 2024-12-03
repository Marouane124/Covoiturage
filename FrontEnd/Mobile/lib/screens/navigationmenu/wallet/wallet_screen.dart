import 'package:flutter/material.dart';
import 'transaction_card.dart';
import '../../../components/bottom_navigation_bar.dart';
import 'add_amount_screen.dart';
import '../../../components/sidemenu.dart';
import 'dart:ui';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 24),
                    _buildAddMoneyButton(context),
                    SizedBox(height: 24),
                    _buildBalanceCards(),
                    SizedBox(height: 24),
                    _buildTransactionsList(),
                  ],
                ),
              ),
            ),
          ),
          if (_isMenuOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  color: Colors.black.withOpacity(0.02),
                ),
              ),
            ),
          if (_isMenuOpen)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SideMenu(),
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.notifications_none, color: Color(0xFF5A5A5A)),
        ),
      ],
    );
  }

  Widget _buildAddMoneyButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAmountScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Color(0xFF008955)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: Text(
          'Add Money',
          style: TextStyle(
            color: Color(0xFF008955),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCards() {
    return Row(
      children: [
        Expanded(child: _buildBalanceCard('Available Balance', '\$500')),
        SizedBox(width: 16),
        Expanded(child: _buildBalanceCard('Total Expend', '\$200')),
      ],
    );
  }

  Widget _buildBalanceCard(String title, String amount) {
    return Container(
      height: 145,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE2F5ED),
        border: Border.all(color: Color(0xFF08B783)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 28,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions',
              style: TextStyle(
                color: Color(0xFF414141),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF007848),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        TransactionCard(
          name: 'Welton',
          time: 'Today at 09:20 am',
          amount: -570.00,
          isDebit: true,
        ),
        SizedBox(height: 16),
        TransactionCard(
          name: 'Nathsam',
          time: 'Today at 09:20 am',
          amount: 570.00,
          isDebit: false,
        ),
        // Add more transaction cards as needed
      ],
    );
  }
} 