import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.deliveries),
      ),
      body: const Center(
        child: Text('Deliveries Screen - Coming Soon'),
      ),
    );
  }
}
