import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reports),
      ),
      body: const Center(
        child: Text('Reports Screen - Coming Soon'),
      ),
    );
  }
}
