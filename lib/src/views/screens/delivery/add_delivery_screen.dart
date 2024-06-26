import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_type_provider.dart';
import 'package:quality_control_mobile/src/data/providers/customer_provider.dart';
import 'package:quality_control_mobile/src/data/providers/delivery_provider.dart';
import 'package:quality_control_mobile/src/models/component_type_models.dart';
import 'package:quality_control_mobile/src/models/customer_models.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';
import 'package:quality_control_mobile/src/views/dialogs/custom_snackbar.dart';
import 'package:quality_control_mobile/src/views/dialogs/error_details_dialog.dart';

class AddDeliveryScreen extends StatefulWidget {
  const AddDeliveryScreen({super.key});

  @override
  AddDeliveryScreenState createState() => AddDeliveryScreenState();
}

class AddDeliveryScreenState extends State<AddDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedComponentType;
  int? _selectedCustomer;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final componentTypeProvider =
        Provider.of<ComponentTypeProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    componentTypeProvider.fetchComponentTypes();
    customerProvider.fetchCustomers();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newDelivery = CreateDeliveryDto(
        componentTypeId: _selectedComponentType!,
        customerId: _selectedCustomer!,
        deliveryDate: _selectedDate?.toIso8601String() ??
            DateTime.now().toIso8601String(),
      );
      try {
        int newDeliveryId =
            await Provider.of<DeliveryProvider>(context, listen: false)
                .createDelivery(newDelivery);
        CustomSnackbar.showSuccessSnackbar(
            context, "Dostawa została dodana pomyślnie!",
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/delivery-details',
                    arguments: newDeliveryId),
                child: const Text('Szczegóły',
                    style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/delivery-contents',
                    arguments: newDeliveryId),
                child: const Text('Zawartość',
                    style: TextStyle(color: Colors.white)),
              )
            ]);
      } catch (e) {
        CustomSnackbar.showErrorSnackbar(
            context,
            'Błąd przy dodawaniu dostawy: $e',
            () => showDialog(
                context: context,
                builder: (context) => ErrorDetailsDialog(
                      errorMessage: e.toString(),
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Dostawę'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Consumer<ComponentTypeProvider>(
                builder: (context, provider, child) {
                  if (provider.componentTypes.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(labelText: 'Typ komponentu'),
                      value: _selectedComponentType,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedComponentType = newValue;
                        });
                      },
                      items: provider.componentTypes
                          .map((ComponentType componentType) {
                        return DropdownMenuItem<int>(
                          value: componentType.id,
                          child: Text(componentType.name),
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? 'Proszę wybrać typ komponentu' : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Consumer<CustomerProvider>(
                builder: (context, provider, child) {
                  if (provider.customers.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Klient'),
                      value: _selectedCustomer,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedCustomer = newValue;
                        });
                      },
                      items: provider.customers.map((Customer customer) {
                        return DropdownMenuItem<int>(
                          value: customer.id,
                          child: Text(customer.name),
                        );
                      }).toList(),
                      validator: (value) =>
                          value == null ? 'Proszę wybrać klienta' : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                ),
                decoration: const InputDecoration(labelText: 'Data dostawy'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context);
                },
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Proszę podać datę dostawy';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Dodaj Dostawę'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
