import 'package:flutter/material.dart';

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