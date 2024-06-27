import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_status_provider.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/views/dialogs/custom_snackbar.dart';
import 'package:quality_control_mobile/src/views/dialogs/error_details_dialog.dart';

class ComponentManageScreen extends StatefulWidget {
  final int componentId;

  const ComponentManageScreen({super.key, required this.componentId});

  @override
  _ComponentManageScreenState createState() => _ComponentManageScreenState();
}

class _ComponentManageScreenState extends State<ComponentManageScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime? _controlDate;
  late DateTime? _productionDate;
  late int? _statusId;

  @override
  void initState() {
    super.initState();
    final component = Provider.of<ComponentProvider>(context, listen: false)
        .components
        .firstWhere((c) => c.id == widget.componentId);

    _controlDate = component.controlDate;
    _productionDate = component.productionDate;
    _statusId = component.status.id;
  }

  Future<void> _selectProductionDate(BuildContext context) async {
    final DateTime? pickedProductionDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedProductionDate != null &&
        pickedProductionDate != _productionDate) {
      setState(() {
        _productionDate = pickedProductionDate;
      });
    }
  }

  Future<void> _selectControlDate(BuildContext context) async {
    final DateTime? pickedControlDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedControlDate != null && pickedControlDate != _controlDate) {
      setState(() {
        _controlDate = pickedControlDate;
      });
    }
  }

  void _updateComponent() {
    if (_formKey.currentState!.validate()) {
      UpdateComponentDto dto = UpdateComponentDto(
        controlDate: _controlDate,
        productionDate: _productionDate,
        statusId: _statusId,
      );
      Provider.of<ComponentProvider>(context, listen: false)
          .updateComponent(widget.componentId, dto)
          .then((_) {
        CustomSnackbar.showSuccessSnackbar(
            context, "Komponent został zaktualizowany pomyślnie!");
      }).catchError((e) {
        CustomSnackbar.showErrorSnackbar(
            context,
            'Błąd przy aktualizacji komponentu: $e',
            () => showDialog(
                context: context,
                builder: (context) => ErrorDetailsDialog(
                      errorMessage: e.toString(),
                    )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final componentStatuses =
        Provider.of<ComponentStatusProvider>(context, listen: false).statuses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj Komponent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateComponent,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: TextEditingController(
                  text: _controlDate == null
                      ? ''
                      : _controlDate!.toLocal().toString().split(' ')[0],
                ),
                decoration: const InputDecoration(labelText: 'Data dostawy'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectControlDate(context);
                },
                validator: (value) {
                  if (_controlDate == null) {
                    return 'Proszę podać datę kontroli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(
                  text: _productionDate == null
                      ? ''
                      : _productionDate!.toLocal().toString().split(' ')[0],
                ),
                decoration: const InputDecoration(labelText: 'Data dostawy'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectProductionDate(context);
                },
                validator: (value) {
                  if (_productionDate == null) {
                    return 'Proszę podać datę produkcji';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _statusId,
                decoration: const InputDecoration(labelText: 'Status'),
                onChanged: (newValue) {
                  setState(() {
                    _statusId = newValue;
                  });
                },
                items: componentStatuses.map((status) {
                  return DropdownMenuItem<int>(
                    value: status.id,
                    child: Text(status.name),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _updateComponent,
                child: const Text('Zapisz Zmiany'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
