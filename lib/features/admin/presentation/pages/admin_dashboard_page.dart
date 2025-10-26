import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/admin_provider.dart';
import 'add_customer_page.dart';
import 'new_delivery_page.dart';
import 'generate_bill_page.dart';
import 'reports_page.dart';

/// Professional admin dashboard page
class AdminDashboardPage extends StatefulWidget {
  final VoidCallback? onLogout;
  
  const AdminDashboardPage({super.key, this.onLogout});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardOverview(),
    const CustomersScreen(),
    const DeliveriesScreen(),
    const BillingScreen(),
    const ProductsScreen(),
    const ReportsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(AppStrings.logout),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: AppStrings.customers,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: AppStrings.deliveries,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: AppStrings.billing,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            activeIcon: Icon(Icons.inventory),
            label: AppStrings.products,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: AppStrings.reports,
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return AppStrings.dashboard;
      case 1:
        return AppStrings.customers;
      case 2:
        return AppStrings.deliveries;
      case 3:
        return AppStrings.billing;
      case 4:
        return AppStrings.products;
      case 5:
        return AppStrings.reports;
      default:
        return AppStrings.dashboard;
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('No new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminProvider>().logout();
              widget.onLogout?.call();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

/// Dashboard overview with statistics cards
class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final stats = adminProvider.dashboardStats;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Here\'s what\'s happening with your dairy business today.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Cards
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildStatCard(
                    context,
                    AppStrings.totalCustomers,
                    '${stats['customers']?['total'] ?? 0}',
                    Icons.people,
                    AppColors.primary,
                  ),
                  _buildStatCard(
                    context,
                    AppStrings.pendingPayments,
                    '₹${(stats['credit']?['currentBalance'] ?? 0).toStringAsFixed(0)}',
                    Icons.pending_actions,
                    AppColors.warning,
                  ),
                  _buildStatCard(
                    context,
                    AppStrings.todaysDeliveries,
                    '${stats['deliveries']?['today'] ?? 0}',
                    Icons.local_shipping,
                    AppColors.secondary,
                  ),
                  _buildStatCard(
                    context,
                    AppStrings.monthlyRevenue,
                    '₹${(stats['revenue']?['thisMonth'] ?? 0).toStringAsFixed(0)}',
                    Icons.attach_money,
                    AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      'Add Customer',
                      Icons.person_add,
                      AppColors.primary,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCustomerPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      'New Delivery',
                      Icons.add_shopping_cart,
                      AppColors.secondary,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewDeliveryPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      'Generate Bill',
                      Icons.receipt_long,
                      AppColors.accent,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenerateBillPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      'View Reports',
                      Icons.analytics,
                      AppColors.info,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: color,
                    size: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Customers management screen
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<String> _filterOptions = ['All', 'Active', 'Inactive', 'Overdue', 'Low Credit'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Search and Filter Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search customers...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: _filterOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Customers List
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Mock data count
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          'C${index + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text('Customer ${index + 1}'),
                      subtitle: Text('+91-987654321${index + 1}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${(2000 + index * 500).toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? AppColors.success : AppColors.warning,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              index % 2 == 0 ? 'Active' : 'Overdue',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showCustomerDetails(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCustomerDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Customer ${index + 1} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: +91-987654321${index + 1}'),
            Text('Address: ${index + 1}23 Main Street, Mumbai'),
            Text('Credit Limit: ₹${(5000 + index * 1000).toString()}'),
            Text('Current Balance: ₹${(2000 + index * 500).toString()}'),
            Text('Status: ${index % 2 == 0 ? 'Active' : 'Overdue'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Deliveries management screen
class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  String _selectedFilter = 'All';
  List<String> _filterOptions = ['All', 'Pending', 'In Progress', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Filter Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      isExpanded: true,
                      items: _filterOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddDeliveryDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Delivery'),
                  ),
                ],
              ),
            ),
            // Deliveries List
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Mock data count
                itemBuilder: (context, index) {
                  final statuses = ['Pending', 'In Progress', 'Completed', 'Cancelled'];
                  final status = statuses[index % statuses.length];
                  final statusColor = _getStatusColor(status);
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.local_shipping, color: Colors.white),
                      ),
                      title: Text('Delivery #DEL${(index + 1).toString().padLeft(3, '0')}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer ${index + 1}'),
                          Text('${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().subtract(Duration(days: index)).month}/${DateTime.now().subtract(Duration(days: index)).year}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${(120 + index * 50).toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showDeliveryDetails(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'In Progress':
        return AppColors.info;
      case 'Completed':
        return AppColors.success;
      case 'Cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showDeliveryDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delivery #DEL${(index + 1).toString().padLeft(3, '0')}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: Customer ${index + 1}'),
            Text('Date: ${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().subtract(Duration(days: index)).month}/${DateTime.now().subtract(Duration(days: index)).year}'),
            Text('Amount: ₹${(120 + index * 50).toString()}'),
            Text('Status: ${['Pending', 'In Progress', 'Completed', 'Cancelled'][index % 4]}'),
            Text('Items: Fresh Cow Milk (2L), Fresh Curd (0.5Kg)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddDeliveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Delivery'),
        content: const Text('Add delivery functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delivery added successfully!')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Billing management screen
class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  String _selectedFilter = 'All';
  List<String> _filterOptions = ['All', 'Pending', 'Paid', 'Overdue', 'Draft'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Filter Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      isExpanded: true,
                      items: _filterOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showGenerateBillDialog(context);
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Generate Bill'),
                  ),
                ],
              ),
            ),
            // Bills List
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Mock data count
                itemBuilder: (context, index) {
                  final statuses = ['Pending', 'Paid', 'Overdue'];
                  final status = statuses[index % statuses.length];
                  final statusColor = _getBillStatusColor(status);
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.receipt, color: Colors.white),
                      ),
                      title: Text('Bill #INV-2024-00${index + 1}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer ${index + 1}'),
                          Text('Due: ${DateTime.now().add(Duration(days: 15 - index * 5)).day}/${DateTime.now().add(Duration(days: 15 - index * 5)).month}/${DateTime.now().add(Duration(days: 15 - index * 5)).year}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${(3600 + index * 1000).toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showBillDetails(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getBillStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'Paid':
        return AppColors.success;
      case 'Overdue':
        return AppColors.error;
      case 'Draft':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showBillDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bill #INV-2024-00${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: Customer ${index + 1}'),
            Text('Amount: ₹${(3600 + index * 1000).toString()}'),
            Text('Status: ${['Pending', 'Paid', 'Overdue'][index % 3]}'),
            Text('Due Date: ${DateTime.now().add(Duration(days: 15 - index * 5)).day}/${DateTime.now().add(Duration(days: 15 - index * 5)).month}/${DateTime.now().add(Duration(days: 15 - index * 5)).year}'),
            Text('Items: Fresh Cow Milk (60L), Fresh Curd (15Kg)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGenerateBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate New Bill'),
        content: const Text('Generate bill functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bill generated successfully!')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}

/// Products management screen
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedFilter = 'All';
  List<String> _filterOptions = ['All', 'Available', 'Low Stock', 'Out of Stock', 'Discontinued'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Filter Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      isExpanded: true,
                      items: _filterOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddProductDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ],
              ),
            ),
            // Products List
            Expanded(
              child: ListView.builder(
                itemCount: 6, // Mock data count
                itemBuilder: (context, index) {
                  final products = [
                    {'name': 'Fresh Cow Milk', 'price': '₹60', 'stock': '500L', 'status': 'Available'},
                    {'name': 'Buffalo Milk', 'price': '₹80', 'stock': '300L', 'status': 'Available'},
                    {'name': 'Fresh Curd', 'price': '₹120', 'stock': '100Kg', 'status': 'Available'},
                    {'name': 'Butter', 'price': '₹400', 'stock': '50Kg', 'status': 'Available'},
                    {'name': 'Paneer', 'price': '₹300', 'stock': '25Kg', 'status': 'Low Stock'},
                    {'name': 'Ghee', 'price': '₹600', 'stock': '0Kg', 'status': 'Out of Stock'},
                  ];
                  
                  final product = products[index];
                  final statusColor = _getProductStatusColor(product['status']!);
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.local_drink, color: Colors.white),
                      ),
                      title: Text(product['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: ${product['price']}'),
                          Text('Stock: ${product['stock']}'),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product['status']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        _showProductDetails(context, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getProductStatusColor(String status) {
    switch (status) {
      case 'Available':
        return AppColors.success;
      case 'Low Stock':
        return AppColors.warning;
      case 'Out of Stock':
        return AppColors.error;
      case 'Discontinued':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showProductDetails(BuildContext context, int index) {
    final products = [
      {'name': 'Fresh Cow Milk', 'price': '₹60', 'stock': '500L', 'status': 'Available', 'category': 'Milk'},
      {'name': 'Buffalo Milk', 'price': '₹80', 'stock': '300L', 'status': 'Available', 'category': 'Milk'},
      {'name': 'Fresh Curd', 'price': '₹120', 'stock': '100Kg', 'status': 'Available', 'category': 'Curd'},
      {'name': 'Butter', 'price': '₹400', 'stock': '50Kg', 'status': 'Available', 'category': 'Butter'},
      {'name': 'Paneer', 'price': '₹300', 'stock': '25Kg', 'status': 'Low Stock', 'category': 'Paneer'},
      {'name': 'Ghee', 'price': '₹600', 'stock': '0Kg', 'status': 'Out of Stock', 'category': 'Ghee'},
    ];
    
    final product = products[index];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['name']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${product['category']}'),
            Text('Price: ${product['price']}'),
            Text('Stock: ${product['stock']}'),
            Text('Status: ${product['status']}'),
            Text('Description: Pure, fresh dairy product'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product'),
        content: const Text('Add product functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added successfully!')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Reports and analytics screen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Revenue Overview
              Text(
                'Revenue Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Total Revenue',
                      '₹2,50,000',
                      Icons.attach_money,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'This Month',
                      '₹45,000',
                      Icons.trending_up,
                      AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Growth Rate',
                      '+15%',
                      Icons.show_chart,
                      AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Avg Order',
                      '₹1,200',
                      Icons.shopping_cart,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Customer Analytics
              Text(
                'Customer Analytics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Total Customers',
                      '2,000',
                      Icons.people,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Active Customers',
                      '1,850',
                      Icons.people_outline,
                      AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'New This Month',
                      '45',
                      Icons.person_add,
                      AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Retention Rate',
                      '92%',
                      Icons.loyalty,
                      AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Delivery Analytics
              Text(
                'Delivery Analytics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Total Deliveries',
                      '5,200',
                      Icons.local_shipping,
                      AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Success Rate',
                      '98%',
                      Icons.check_circle,
                      AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Avg Delivery Time',
                      '2.5 hrs',
                      Icons.access_time,
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReportCard(
                      context,
                      'Customer Rating',
                      '4.8/5',
                      Icons.star,
                      AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: color,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
