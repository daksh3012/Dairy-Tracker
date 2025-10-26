import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/bill.dart';
import '../../../../shared/models/customer.dart';

/// Generate Bill page for admin
class GenerateBillPage extends StatefulWidget {
  const GenerateBillPage({super.key});

  @override
  State<GenerateBillPage> createState() => _GenerateBillPageState();
}

class _GenerateBillPageState extends State<GenerateBillPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCustomerId = '';
  DateTime _billDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  BillStatus _selectedStatus = BillStatus.pending;

  // Mock customers for demo
  final List<Customer> _customers = [
    Customer(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '+1234567890',
      address: '123 Main St',
      area: 'Downtown',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      joinDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Customer(
      id: '2',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane@example.com',
      phone: '+1234567891',
      address: '456 Oak Ave',
      area: 'Uptown',
      city: 'New York',
      state: 'NY',
      zipCode: '10002',
      joinDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  final List<BillItem> _billItems = [];

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Bill'),
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
              // Customer Information Card
              _buildSectionCard(
                'Customer Information',
                Icons.person,
                [
                  DropdownButtonFormField<String>(
                    value: _selectedCustomerId.isEmpty ? null : _selectedCustomerId,
                    decoration: const InputDecoration(
                      labelText: 'Select Customer *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    items: _customers.map((customer) {
                      return DropdownMenuItem(
                        value: customer.id,
                        child: Text('${customer.fullName} (${customer.phone})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomerId = value!;
                        final customer = _customers.firstWhere((c) => c.id == value);
                        _customerNameController.text = customer.fullName;
                        _customerPhoneController.text = customer.phone;
                        _customerAddressController.text = customer.fullAddress;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a customer';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customerPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customerAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                    readOnly: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bill Information Card
              _buildSectionCard(
                'Bill Information',
                Icons.receipt_long,
                [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectBillDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Bill Date *',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              '${_billDate.day}/${_billDate.month}/${_billDate.year}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: _selectDueDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Due Date *',
                              prefixIcon: Icon(Icons.event),
                            ),
                            child: Text(
                              '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<BillStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                    items: BillStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      prefixIcon: Icon(Icons.note_outlined),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bill Items Card
              _buildSectionCard(
                'Bill Items',
                Icons.shopping_cart,
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items (${_billItems.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addBillItem,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_billItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'No items added yet.\nTap "Add Item" to add bill items.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._billItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.description),
                          subtitle: Text('${item.quantity} × ₹${item.unitPrice}'),
                          trailing: Text(
                            '₹${item.totalAmount}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _billItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
              const SizedBox(height: 24),

              // Bill Summary Card
              if (_billItems.isNotEmpty) ...[
                _buildSectionCard(
                  'Bill Summary',
                  Icons.calculate,
                  [
                    _buildSummaryRow('Subtotal', _getSubtotal()),
                    _buildSummaryRow('Tax (10%)', _getTax()),
                    const Divider(),
                    _buildSummaryRow('Total Amount', _getTotalAmount(), isTotal: true),
                  ],
                ),
                const SizedBox(height: 24),
              ],

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
                      onPressed: _billItems.isNotEmpty ? _generateBill : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Generate Bill'),
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

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
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
            '₹${amount.toStringAsFixed(2)}',
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

  Future<void> _selectBillDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _billDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _billDate) {
      setState(() {
        _billDate = picked;
      });
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: _billDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _addBillItem() {
    showDialog(
      context: context,
      builder: (context) => _AddBillItemDialog(
        onAdd: (item) {
          setState(() {
            _billItems.add(item);
          });
        },
      ),
    );
  }

  double _getSubtotal() {
    return _billItems.fold(0.0, (sum, item) => sum + item.totalAmount);
  }

  double _getTax() {
    return _getSubtotal() * 0.10; // 10% tax
  }

  double _getTotalAmount() {
    return _getSubtotal() + _getTax();
  }

  void _generateBill() {
    if (_formKey.currentState!.validate()) {
      if (_billItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one bill item'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create bill object
      final bill = Bill(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: _selectedCustomerId,
        customerName: _customerNameController.text.trim(),
        billNumber: 'BILL-${DateTime.now().millisecondsSinceEpoch}',
        billDate: _billDate,
        dueDate: _dueDate,
        status: _selectedStatus,
        items: _billItems,
        subtotal: _getSubtotal(),
        taxAmount: _getTax(),
        totalAmount: _getTotalAmount(),
        paidAmount: 0.0,
        balanceAmount: _getTotalAmount(),
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill generated successfully! Total: ₹${_getTotalAmount().toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }
}

/// Dialog for adding bill items
class _AddBillItemDialog extends StatefulWidget {
  final Function(BillItem) onAdd;

  const _AddBillItemDialog({required this.onAdd});

  @override
  State<_AddBillItemDialog> createState() => _AddBillItemDialogState();
}

class _AddBillItemDialogState extends State<_AddBillItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Bill Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Quantity is required';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Enter valid quantity';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _unitPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Unit Price (₹) *',
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Unit price is required';
                      }
                      if (double.tryParse(value) == null || double.parse(value) < 0) {
                        return 'Enter valid price';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addItem,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final quantity = double.parse(_quantityController.text);
      final unitPrice = double.parse(_unitPriceController.text);
      final totalAmount = quantity * unitPrice;

      final item = BillItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text.trim(),
        quantity: quantity,
        unitPrice: unitPrice,
        totalAmount: totalAmount,
      );

      widget.onAdd(item);
      Navigator.pop(context);
    }
  }
}
