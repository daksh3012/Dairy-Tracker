import 'package:flutter/material.dart';
import '../../../constants/app_strings.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.products),
      ),
      body: const Center(
        child: Text('Products Screen - Coming Soon'),
      ),
    );
  }
}
