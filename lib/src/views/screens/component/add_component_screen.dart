import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/views/dialogs/custom_snackbar.dart';
import 'package:quality_control_mobile/src/views/dialogs/error_details_dialog.dart';

class AddComponentScreen extends StatefulWidget {
  const AddComponentScreen({super.key});

  @override
  AddComponentScreenState createState() => AddComponentScreenState();
}

class AddComponentScreenState extends State<AddComponentScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _componentName;
  DateTime? _controlDate;
  DateTime? _productionDate;
  double? _componentSize;
  int? _deliveryId;

  Future<void> _selectDate(BuildContext context, bool isControlDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isControlDate) {
          _controlDate = picked;
        } else {
          _productionDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newComponent = CreateComponentDto(
        name: _componentName!,
        controlDate: _controlDate,
        productionDate: _productionDate,
        size: _componentSize!,
        deliveryId: _deliveryId!,
      );
      try {
        int newComponentId =
            await Provider.of<ComponentProvider>(context, listen: false)
                .createComponent(newComponent);
        CustomSnackbar.showSuccessSnackbar(
            context, "Komponent został dodany pomyślnie!",
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/component-details',
                    arguments: newComponentId),
                child: const Text('Szczegóły',
                    style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/component-manage',
                    arguments: newComponentId),
                child: const Text('Zawartość',
                    style: TextStyle(color: Colors.white)),
              )
            ]);
      } catch (e) {
        CustomSnackbar.showErrorSnackbar(
            context,
            'Błąd przy dodawaniu komponentu: $e',
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
        title: const Text('Dodaj Komponent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Numer komponentu'),
                onChanged: (value) {
                  _componentName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać nazwę komponentu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Numer dostawy'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _deliveryId = int.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać numer dostawy';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Rozmiar komponentu'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  _componentSize = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać rozmiar komponentu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _controlDate == null
                      ? ''
                      : _controlDate!.toLocal().toString().split(' ')[0],
                ),
                decoration: const InputDecoration(labelText: 'Data kontroli'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context, true);
                },
                validator: (value) {
                  if (_controlDate == null) {
                    return 'Proszę podać datę kontroli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _productionDate == null
                      ? ''
                      : _productionDate!.toLocal().toString().split(' ')[0],
                ),
                decoration: const InputDecoration(labelText: 'Data produkcji'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context, false);
                },
                validator: (value) {
                  if (_productionDate == null) {
                    return 'Proszę podać datę produkcji';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Dodaj Komponent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
