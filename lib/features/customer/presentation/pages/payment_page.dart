import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/bill.dart';

/// Payment page for customer
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardNameController = TextEditingController();

  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  String _selectedBillId = '';

  // Mock bills for demo
  final List<Bill> _bills = [
    Bill(
      id: '1',
      customerId: 'customer_1',
      customerName: 'John Doe',
      customerPhone: '+1234567890',
      customerAddress: '123 Main St, New York, NY 10001',
      billNumber: 'BILL-001',
      billDate: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      status: BillStatus.pending,
      items: [
        BillItem(
          id: '1',
          productId: 'prod_1',
          productName: 'Fresh Milk (1L)',
          productUnit: 'liter',
          quantity: 7,
          unitPrice: 50.0,
          totalPrice: 350.0,
          description: 'Fresh Milk (1L) x 7',
        ),
        BillItem(
          id: '2',
          productId: 'prod_2',
          productName: 'Curd (500g)',
          productUnit: 'gram',
          quantity: 3,
          unitPrice: 30.0,
          totalPrice: 90.0,
          description: 'Curd (500g) x 3',
        ),
      ],
      subtotal: 440.0,
      taxAmount: 44.0,
      discountAmount: 0.0,
      totalAmount: 484.0,
      paidAmount: 0.0,
      balanceAmount: 484.0,
    ),
    Bill(
      id: '2',
      customerId: 'customer_1',
      customerName: 'John Doe',
      customerPhone: '+1234567890',
      customerAddress: '123 Main St, New York, NY 10001',
      billNumber: 'BILL-002',
      billDate: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 25)),
      status: BillStatus.pending,
      items: [
        BillItem(
          id: '3',
          productId: 'prod_3',
          productName: 'Paneer (250g)',
          productUnit: 'gram',
          quantity: 2,
          unitPrice: 200.0,
          totalPrice: 400.0,
          description: 'Paneer (250g) x 2',
        ),
      ],
      subtotal: 400.0,
      taxAmount: 40.0,
      discountAmount: 0.0,
      totalAmount: 440.0,
      paidAmount: 0.0,
      balanceAmount: 440.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_bills.isNotEmpty) {
      _selectedBillId = _bills.first.id;
      _amountController.text = _bills.first.balanceAmount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bill Selection Card
              _buildSectionCard(
                'Select Bill',
                Icons.receipt_long,
                [
                  DropdownButtonFormField<String>(
                    value: _selectedBillId.isEmpty ? null : _selectedBillId,
                    decoration: const InputDecoration(
                      labelText: 'Select Bill to Pay *',
                      prefixIcon: Icon(Icons.receipt),
                    ),
                    items: _bills.map((bill) {
                      return DropdownMenuItem(
                        value: bill.id,
                        child: Text('${bill.billNumber} - ₹${bill.balanceAmount.toStringAsFixed(2)}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBillId = value!;
                        final bill = _bills.firstWhere((b) => b.id == value);
                        _amountController.text = bill.balanceAmount.toStringAsFixed(2);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a bill';
                      }
                      return null;
                    },
                  ),
                  if (_selectedBillId.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildBillDetails(),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Payment Amount Card
              _buildSectionCard(
                'Payment Amount',
                Icons.monetization_on,
                [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount to Pay (₹) *',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid amount';
                      }
                      if (_selectedBillId.isNotEmpty) {
                        final bill = _bills.firstWhere((b) => b.id == _selectedBillId);
                        if (amount > bill.balanceAmount) {
                          return 'Amount cannot exceed bill balance';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Payment Method Card
              _buildSectionCard(
                'Payment Method',
                Icons.payment,
                [
                  RadioListTile<PaymentMethod>(
                    title: const Text('Credit/Debit Card'),
                    subtitle: const Text('Visa, Mastercard, American Express'),
                    value: PaymentMethod.card,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  RadioListTile<PaymentMethod>(
                    title: const Text('UPI'),
                    subtitle: const Text('Google Pay, PhonePe, Paytm'),
                    value: PaymentMethod.upi,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  RadioListTile<PaymentMethod>(
                    title: const Text('Net Banking'),
                    subtitle: const Text('Bank transfer'),
                    value: PaymentMethod.netBanking,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Payment Details Card
              if (_selectedPaymentMethod == PaymentMethod.card) ...[
                _buildSectionCard(
                  'Card Details',
                  Icons.credit_card,
                  [
                    TextFormField(
                      controller: _cardNameController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder Name *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cardholder name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Card Number *',
                        prefixIcon: Icon(Icons.credit_card),
                        hintText: '1234 5678 9012 3456',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Card number is required';
                        }
                        if (value.replaceAll(' ', '').length < 16) {
                          return 'Enter a valid card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date *',
                              prefixIcon: Icon(Icons.calendar_today),
                              hintText: 'MM/YY',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Expiry date is required';
                              }
                              if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                                return 'Enter valid expiry date (MM/YY)';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'CVV *',
                              prefixIcon: Icon(Icons.security),
                              hintText: '123',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'CVV is required';
                              }
                              if (value.length < 3) {
                                return 'Enter valid CVV';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Payment Summary Card
              _buildSectionCard(
                'Payment Summary',
                Icons.summarize,
                [
                  _buildSummaryRow('Bill Number', _getBillNumber()),
                  _buildSummaryRow('Amount to Pay', '₹${_amountController.text}'),
                  _buildSummaryRow('Payment Method', _getPaymentMethodName()),
                  const Divider(),
                  _buildSummaryRow('Total', '₹${_amountController.text}', isTotal: true),
                ],
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetails() {
    final bill = _bills.firstWhere((b) => b.id == _selectedBillId);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Details',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Bill Date', '${bill.billDate.day}/${bill.billDate.month}/${bill.billDate.year}'),
          _buildDetailRow('Due Date', '${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}'),
          _buildDetailRow('Total Amount', '₹${bill.totalAmount.toStringAsFixed(2)}'),
          _buildDetailRow('Paid Amount', '₹${bill.paidAmount.toStringAsFixed(2)}'),
          _buildDetailRow('Balance', '₹${bill.balanceAmount.toStringAsFixed(2)}', isBalance: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBalance = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: isBalance ? FontWeight.bold : FontWeight.normal,
              color: isBalance ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getBillNumber() {
    if (_selectedBillId.isEmpty) return 'N/A';
    final bill = _bills.firstWhere((b) => b.id == _selectedBillId);
    return bill.billNumber;
  }

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.netBanking:
        return 'Net Banking';
    }
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Simulate payment processing
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Close loading dialog

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Payment Successful'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment of ₹${_amountController.text} has been processed successfully.'),
                const SizedBox(height: 8),
                Text('Transaction ID: TXN${DateTime.now().millisecondsSinceEpoch}'),
                const SizedBox(height: 8),
                Text('Bill: ${_getBillNumber()}'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }
}

/// Payment method enumeration
enum PaymentMethod {
  card,
  upi,
  netBanking,
}
