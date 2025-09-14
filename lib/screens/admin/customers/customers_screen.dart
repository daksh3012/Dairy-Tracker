import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_colors.dart';
import 'add_customer_screen.dart';
import 'customer_details_screen.dart';

/// Customers management screen with search and filter functionality
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchCustomers,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<CustomerProvider>().searchCustomers('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGray,
                  ),
                  onChanged: (value) {
                    context.read<CustomerProvider>().searchCustomers(value);
                  },
                ),
                const SizedBox(height: 12),
                
                // Filter Row
                Consumer<CustomerProvider>(
                  builder: (context, customerProvider, child) {
                    return Row(
                      children: [
                        // Area Filter
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: customerProvider.selectedArea.isEmpty 
                                ? null 
                                : customerProvider.selectedArea,
                            decoration: InputDecoration(
                              labelText: 'Area',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: '',
                                child: Text('All Areas'),
                              ),
                              ...customerProvider.uniqueAreas.map(
                                (area) => DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              customerProvider.filterByArea(value ?? '');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // City Filter
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: customerProvider.selectedCity.isEmpty 
                                ? null 
                                : customerProvider.selectedCity,
                            decoration: InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: '',
                                child: Text('All Cities'),
                              ),
                              ...customerProvider.uniqueCities.map(
                                (city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              customerProvider.filterByCity(value ?? '');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Active Filter Toggle
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderLight),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SwitchListTile(
                            title: const Text('Active Only'),
                            value: customerProvider.showActiveOnly,
                            onChanged: (value) {
                              customerProvider.toggleActiveFilter();
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            dense: true,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                
                // Clear Filters Button
                Consumer<CustomerProvider>(
                  builder: (context, customerProvider, child) {
                    if (customerProvider.searchQuery.isNotEmpty ||
                        customerProvider.selectedArea.isNotEmpty ||
                        customerProvider.selectedCity.isNotEmpty ||
                        !customerProvider.showActiveOnly) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              customerProvider.clearFilters();
                              _searchController.clear();
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear Filters'),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Statistics Bar
          Consumer<CustomerProvider>(
            builder: (context, customerProvider, child) {
              final stats = customerProvider.customerStats;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.borderLight,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Total', stats['total'].toString(), AppColors.primaryGreen),
                    _buildStatItem('Active', stats['active'].toString(), AppColors.success),
                    _buildStatItem('Inactive', stats['inactive'].toString(), AppColors.warning),
                    _buildStatItem('Overdue', stats['overdue'].toString(), AppColors.error),
                  ],
                ),
              );
            },
          ),

          // Customers List
          Expanded(
            child: Consumer<CustomerProvider>(
              builder: (context, customerProvider, child) {
                if (customerProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (customerProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          customerProvider.errorMessage!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            customerProvider.loadCustomers();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final customers = customerProvider.filteredCustomers;
                if (customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No customers found',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return _buildCustomerCard(context, customer);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCustomerScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(BuildContext context, customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerDetailsScreen(customer: customer),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Customer Avatar
                  CircleAvatar(
                    backgroundColor: customer.isActive 
                        ? AppColors.primaryGreen 
                        : AppColors.textLight,
                    child: Text(
                      customer.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Customer Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer.phone,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${customer.area}, ${customer.city}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: customer.isActive 
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      customer.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: customer.isActive ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Balance and Credit Info
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Balance',
                      '₹${customer.currentBalance.toStringAsFixed(0)}',
                      customer.isOverdue ? AppColors.error : AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Credit Limit',
                      '₹${customer.creditLimit.toStringAsFixed(0)}',
                      AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Available',
                      '₹${customer.availableCredit.toStringAsFixed(0)}',
                      AppColors.success,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Delivery Info
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${customer.deliveryDays.length} days/week',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    customer.deliveryTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
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

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
