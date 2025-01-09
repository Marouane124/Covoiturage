import 'package:flutter/material.dart';
import '../../../services/payment_service.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../map_screen.dart';  // Add import for MapScreen

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<dynamic> payments = [];
  final PaymentService paymentService = PaymentService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      final fetchedPayments = await paymentService.getAllPayments();
      setState(() {
        payments = fetchedPayments;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching payments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "Unknown Date";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Future<void> _updatePayment(String paymentId, Map<String, dynamic> updatedData) async {
    try {
      // Log the data to ensure it's correct
      print("Updating Payment with ID: $paymentId, Data: $updatedData");

      final updatedPayment = await paymentService.updatePayment(paymentId, updatedData);

      // Log the response to confirm it's successful
      print("Updated Payment Response: $updatedPayment");

      setState(() {
        final index = payments.indexWhere((payment) => payment['id'] == paymentId);
        if (index != -1) {
          payments[index] = updatedPayment;  // Update the payment at the correct index
        }
      });

      // Show success message
      _showSnackBar("Payment updated successfully", Colors.green);

      // Re-fetch payments to ensure the latest data is displayed
      await _fetchPayments();
    } catch (e) {
      print("Error updating payment: $e");
      // Show error message
      _showSnackBar("Failed to update payment", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _deletePayment(String paymentId) async {
    try {
      await paymentService.deletePayment(paymentId);
      setState(() {
        payments.removeWhere((payment) => payment['id'] == paymentId);
      });
    } catch (e) {
      print("Error deleting payment: $e");
    }
  }

  void _showPaymentDetails(BuildContext context, Map<String, dynamic> payment) {
    final TextEditingController amountController = TextEditingController(text: payment['montant'].toString());
    final TextEditingController cardController = TextEditingController(text: payment['carteBancaire'] ?? '');
    final TextEditingController cardNumberController = TextEditingController(text: payment['numeroCarte'] ?? '');
    final TextEditingController expirationController = TextEditingController(text: payment['dateExpiration'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: cardController,
                    label: "Card Type",
                    prefixIcon: Icons.credit_card,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: cardNumberController,
                    label: "Card Number",
                    prefixIcon: Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: expirationController,
                    label: "Expiration Date",
                    prefixIcon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: amountController,
                    label: "Amount",
                    prefixIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Payment Date: ${formatDate(payment['datePaiement'])}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _deletePayment(payment['id']);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Delete"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final updatedData = {
                            'carteBancaire': cardController.text,
                            'numeroCarte': cardNumberController.text,
                            'dateExpiration': expirationController.text,
                            'montant': double.tryParse(amountController.text) ?? payment['montant'],
                            'datePaiement': payment['datePaiement'],
                          };
                          _updatePayment(payment['id'], updatedData);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Update"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreatePaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController cardController = TextEditingController();
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expirationController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Payment",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      controller: cardController,
                      label: "Card Type",
                      prefixIcon: Icons.credit_card,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: cardNumberController,
                      label: "Card Number",
                      prefixIcon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        if (value.length < 16 || value.length > 19) {
                          return 'Card number must be between 16 and 19 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: expirationController,
                      label: "Expiration Date",
                      prefixIcon: Icons.calendar_today,
                      hintText: "MM/YY",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiration date';
                        }
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                          return 'Use format MM/YY';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: amountController,
                      label: "Amount",
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Amount must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final paymentData = {
                                'carteBancaire': cardController.text,
                                'numeroCarte': cardNumberController.text,
                                'dateExpiration': expirationController.text,
                                'montant': double.parse(amountController.text),
                                'datePaiement': DateTime.now().toIso8601String(),
                              };

                              try {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                    );
                                  },
                                );

                                await paymentService.createPayment(paymentData);
                                Navigator.of(context).pop(); // Close loading
                                Navigator.of(context).pop(); // Close dialog
                                await _fetchPayments();
                                _showSnackBar(
                                  "Payment created successfully",
                                  Colors.green,
                                );
                              } catch (e) {
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop(); // Close loading
                                }
                                _showSnackBar(
                                  "Failed to create payment: ${e.toString()}",
                                  Colors.red,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Create"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          },
        ),
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.green))
            : Column(
                children: [
                  _buildWalletHeader(),
                  const SizedBox(height: 8),
                  Expanded(child: _buildTransactionsList()),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePaymentDialog,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
    );
  }

  Widget _buildWalletHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Wallet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            onPressed: _fetchPayments,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, 
              size: 64, 
              color: Colors.grey[400]
            ),
            const SizedBox(height: 16),
            const Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        final amount = payment['montant'] ?? 0.0;
        final isPositive = amount > 0;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              payment['carteBancaire'] ?? 'Card Payment',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              formatDate(payment['datePaiement']),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              '${amount.toStringAsFixed(2)} DH',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () => _showPaymentDetails(context, payment),
          ),
        );
      },
    );
  }
}
