import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final dynamic customer;
  
  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.customerDetails),
      ),
      body: Center(
        child: Text('Customer Details Screen - Coming Soon\nCustomer: ${customer.name}'),
      ),
    );
  }
}
