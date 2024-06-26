import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
// import 'package:quality_control_mobile/src/data/services/component_service.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';

class AddComponentScreen extends StatefulWidget {
  const AddComponentScreen({super.key});

  @override
  AddComponentScreenState createState() => AddComponentScreenState();
}

class AddComponentScreenState extends State<AddComponentScreen> {
  final _formKey = GlobalKey<FormState>();
  // final ComponentService componentService = ComponentService();

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
        await Provider.of<ComponentProvider>(context, listen: true)
            .createComponent(newComponent);
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
                        "Komponent został dodany pomyślnie!",
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
          SnackBar(content: Text('Błąd przy dodawaniu komponentu: $e')),
        );
      }
    }
  }

  // Future<void> _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     final newComponent = CreateComponentDto(
  //       name: _componentName!,
  //       controlDate: _controlDate,
  //       productionDate: _productionDate,
  //       size: _componentSize!,
  //       deliveryId: _deliveryId!,
  //     );
  //     try {
  //       await componentService.createComponent(newComponent);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Container(
  //           padding: const EdgeInsets.all(8),
  //           height: 75,
  //           decoration: const BoxDecoration(
  //             color: Colors.green,
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //           ),
  //           child: const Row(
  //             children: [
  //               Icon(
  //                 Icons.check_circle,
  //                 color: Colors.white,
  //                 size: 40,
  //               ),
  //               SizedBox(
  //                 width: 20,
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Sukces!",
  //                       style: TextStyle(
  //                           fontSize: 18,
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold),
  //                       maxLines: 1,
  //                     ),
  //                     Text(
  //                       "Komponent został dodany pomyślnie!",
  //                       style: TextStyle(color: Colors.white, fontSize: 14),
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.transparent,
  //         elevation: 3,
  //       ));
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Błąd przy dodawaniu komponentu: $e')),
  //       );
  //     }
  //   }
  // }

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
                    const InputDecoration(labelText: 'Nazwa komponentu'),
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
