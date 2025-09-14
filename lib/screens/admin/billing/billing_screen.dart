import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.billing),
      ),
      body: const Center(
        child: Text('Billing Screen - Coming Soon'),
      ),
    );
  }
}
