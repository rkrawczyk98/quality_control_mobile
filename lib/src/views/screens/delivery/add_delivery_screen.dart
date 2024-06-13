import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/services/component_type_service.dart';
import 'package:quality_control_mobile/src/data/services/customer_service.dart';
import 'package:quality_control_mobile/src/data/services/delivery_service.dart';
import 'package:quality_control_mobile/src/models/component_type_models.dart';
import 'package:quality_control_mobile/src/models/customer_models.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';

class AddDeliveryScreen extends StatefulWidget {
  const AddDeliveryScreen({super.key});

  @override
  AddDeliveryScreenState createState() => AddDeliveryScreenState();
}

class AddDeliveryScreenState extends State<AddDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final ComponentTypeService componentTypeService = ComponentTypeService();
  final CustomerService customerService = CustomerService();
  final DeliveryService deliveryService = DeliveryService();

  late Future<List<ComponentType>> componentTypes;
  late Future<List<Customer>> customers;

  int? _selectedComponentType;
  int? _selectedCustomer;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    componentTypes = componentTypeService.fetchComponentTypes();
    customers = customerService.fetchCustomers();
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
        await deliveryService.createDelivery(newDelivery); //To DO ZROBIENIA
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 75,
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sukces!",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                            maxLines: 1,
                      ),
                      Text(
                        "Dostawa została dodana pomyślnie!",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 3,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd przy dodawaniu dostawy: $e')),
        );
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
              FutureBuilder<List<ComponentType>>(
                future: componentTypes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No component types available');
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
                      items: snapshot.data!.map((ComponentType componentType) {
                        return DropdownMenuItem<int>(
                          value: componentType.id,
                          child: Text(componentType.name),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Proszę wybrać typ komponentu';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Customer>>(
                future: customers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No customers available');
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Klient'),
                      value: _selectedCustomer,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedCustomer = newValue;
                        });
                      },
                      items: snapshot.data!.map((Customer customer) {
                        return DropdownMenuItem<int>(
                          value: customer.id,
                          child: Text(customer.name),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Proszę wybrać klienta';
                        }
                        return null;
                      },
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
