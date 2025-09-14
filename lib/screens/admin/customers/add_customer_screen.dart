import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addCustomer),
      ),
      body: const Center(
        child: Text('Add Customer Screen - Coming Soon'),
      ),
    );
  }
}
