import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/delivery.dart';
import '../../../../shared/models/customer.dart';

/// New Delivery page for admin
class NewDeliveryPage extends StatefulWidget {
  const NewDeliveryPage({super.key});

  @override
  State<NewDeliveryPage> createState() => _NewDeliveryPageState();
}

class _NewDeliveryPageState extends State<NewDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _notesController = TextEditingController();
  final _deliveryPersonController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DeliveryTimeSlot _selectedDeliveryTime = DeliveryTimeSlot.morning;
  DeliveryStatus _selectedStatus = DeliveryStatus.pending;
  String _selectedCustomerId = '';

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

  final List<DeliveryItem> _deliveryItems = [];

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _deliveryAddressController.dispose();
    _notesController.dispose();
    _deliveryPersonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Delivery'),
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
                        _deliveryAddressController.text = customer.fullAddress;
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
                ],
              ),
              const SizedBox(height: 24),

              // Delivery Information Card
              _buildSectionCard(
                'Delivery Information',
                Icons.delivery_dining,
                [
                  TextFormField(
                    controller: _deliveryAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Address *',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Delivery address is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Delivery Date *',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<DeliveryTimeSlot>(
                          value: _selectedDeliveryTime,
                          decoration: const InputDecoration(
                            labelText: 'Delivery Time *',
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          items: DeliveryTimeSlot.values.map((time) {
                            return DropdownMenuItem(
                              value: time,
                              child: Text(time.displayName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDeliveryTime = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _deliveryPersonController,
                          decoration: const InputDecoration(
                            labelText: 'Delivery Person',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<DeliveryStatus>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            prefixIcon: Icon(Icons.info_outline),
                          ),
                          items: DeliveryStatus.values.map((status) {
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
                      ),
                    ],
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

              // Delivery Items Card
              _buildSectionCard(
                'Delivery Items',
                Icons.shopping_cart,
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items (${_deliveryItems.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addDeliveryItem,
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
                  if (_deliveryItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'No items added yet.\nTap "Add Item" to add delivery items.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._deliveryItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.productName),
                          subtitle: Text('${item.quantity} ${item.productUnit} × ₹${item.unitPrice}'),
                          trailing: Text(
                            '₹${item.totalPrice}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _deliveryItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
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
                      onPressed: _deliveryItems.isNotEmpty ? _createDelivery : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Create Delivery'),
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addDeliveryItem() {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(
        onAdd: (item) {
          setState(() {
            _deliveryItems.add(item);
          });
        },
      ),
    );
  }

  void _createDelivery() {
    if (_formKey.currentState!.validate()) {
      if (_deliveryItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one delivery item'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Calculate total amount
      final totalAmount = _deliveryItems.fold(0.0, (sum, item) => sum + item.totalPrice);

      // Create delivery object
      final delivery = Delivery(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: _selectedCustomerId,
        customerName: _customerNameController.text.trim(),
        customerPhone: _customerPhoneController.text.trim(),
        deliveryAddress: _deliveryAddressController.text.trim(),
        deliveryDate: _selectedDate,
        deliveryTime: _selectedDeliveryTime,
        status: _selectedStatus,
        items: _deliveryItems,
        totalAmount: totalAmount,
        deliveryPerson: _deliveryPersonController.text.trim().isEmpty 
            ? null 
            : _deliveryPersonController.text.trim(),
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delivery created successfully! Total: ₹${totalAmount.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }
}

/// Dialog for adding delivery items
class _AddItemDialog extends StatefulWidget {
  final Function(DeliveryItem) onAdd;

  const _AddItemDialog({required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productUnitController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();

  @override
  void dispose() {
    _productNameController.dispose();
    _productUnitController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Delivery Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
                prefixIcon: Icon(Icons.inventory),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product name is required';
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
                    controller: _productUnitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit (kg/ltr)',
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
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
      final totalPrice = quantity * unitPrice;

      final item = DeliveryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        productName: _productNameController.text.trim(),
        productUnit: _productUnitController.text.trim().isEmpty 
            ? 'piece' 
            : _productUnitController.text.trim(),
        quantity: quantity,
        unitPrice: unitPrice,
        totalPrice: totalPrice,
      );

      widget.onAdd(item);
      Navigator.pop(context);
    }
  }
}
