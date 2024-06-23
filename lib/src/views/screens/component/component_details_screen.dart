import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/component_subcomponent_controller.dart';
import 'package:quality_control_mobile/src/data/controllers/subcomponent_status_controller.dart';
import 'package:quality_control_mobile/src/data/services/component_service.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';
import 'package:quality_control_mobile/src/models/subcomponent_status_models.dart'
    as _subcomponentStatusModels;

class ComponentDetailsScreen extends StatefulWidget {
  final int componentId;

  const ComponentDetailsScreen({Key? key, required this.componentId})
      : super(key: key);

  @override
  _ComponentDetailsScreenState createState() => _ComponentDetailsScreenState();
}

class _ComponentDetailsScreenState extends State<ComponentDetailsScreen> {
  late Future<Component> componentFuture =
      ComponentService().fetchComponent(widget.componentId);
  late Future<List<_subcomponentStatusModels.SubcomponentStatus>>
      posibleSubcomponentStatuses =
      SubcomponentStatusController().getSubcomponentStatuses();
  late List<int> _selectedStatuses;

  @override
  void initState() {
    super.initState();
    componentFuture = ComponentService().fetchComponent(widget.componentId);
    componentFuture.then((component) {
      _selectedStatuses = List<int>.generate(component.subcomponents.length,
          (index) => component.subcomponents[index].status.id);
      // _getSubcomponentStatuses();
    });
  }

  void _handleStatusChange(int subcomponentIndex, int newStatusId) async {
    setState(() {
      _selectedStatuses[subcomponentIndex] = newStatusId;
    });
    try {
      await ComponentSubcomponentController()
          .updateSubcomponentStatus(subcomponentIndex, newStatusId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd aktualizacji statusu: $e')));
    }
  }

  // void _getSubcomponentStatuses() async {
  //   try {
  //     _posibleSubcomponentStatuses =
  //         await SubcomponentStatusController().getSubcomponentStatuses();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Błąd pobierania statusów podkomponentów: $e')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Komponentu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Component>(
        future: componentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Brak danych'));
          } else {
            final component = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComponentInfo(
                    name: component.name,
                    controlDate: component.controlDate,
                    productionDate: component.productionDate,
                    size: component.size,
                    creationDate: component.creationDate,
                    lastModified: component.lastModified,
                    deletedAt: component.deletedAt,
                    createdByUser: component.createdByUser.username,
                    modifiedByUser: component.modifiedByUser.username,
                    componentType: component.componentType,
                    status: component.status,
                    delivery: component.delivery.number,
                    deliveryDate: component.delivery.deliveryDate,
                    warehouse: component.warehouse.name,
                    warehousePosition: component.warehousePosition.name,
                    scrappedAt: component.scrappedAt,
                  ),
                  const SizedBox(height: 16),
                  Text('Podkomponenty:',
                      style: Theme.of(context).textTheme.titleLarge),
                  ...component.subcomponents.asMap().entries.map((entry) {
                    int index = entry.key;
                    Subcomponent subcomponent = entry.value;
                    return ListTile(
                        leading: const Icon(Icons.extension),
                        title: Text(subcomponent.name),
                        subtitle: Row(children: [
                          const Text('Status: '),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: _selectedStatuses[index],
                            items: null,
                            // posibleSubcomponentStatuses.map((status) {
                            //   return DropdownMenuItem<int>(
                            //     value: status.id,
                            //     child: Text(status.name),
                            //   );
                            // }).toList(),
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                _handleStatusChange(index, newValue);
                              }
                            },
                          ),
                        ]));
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ComponentInfo extends StatelessWidget {
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final double size;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final String createdByUser;
  final String modifiedByUser;
  final String componentType;
  final String status;
  final String delivery;
  final DateTime? deliveryDate;
  final String warehouse;
  final String warehousePosition;
  final DateTime? scrappedAt;

  const ComponentInfo({
    Key? key,
    required this.name,
    this.controlDate,
    this.productionDate,
    required this.size,
    required this.creationDate,
    required this.lastModified,
    this.deletedAt,
    required this.createdByUser,
    required this.modifiedByUser,
    required this.componentType,
    required this.status,
    required this.delivery,
    required this.deliveryDate,
    required this.warehouse,
    required this.warehousePosition,
    this.scrappedAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Nazwa',
            //         style: TextStyle(color: Colors.grey),
            //       ),
            //       const SizedBox(height: 4),
            //       Text(
            //         name,
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            //   const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            //     Icon(
            //       Icons.info_outline,
            //       color: Colors.green,
            //       size: 30,
            //     ),
            //   ]),
            // ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Nazwa',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Typ',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  componentType,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Numer dostawy',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  delivery, ////////////////////////////////////////////////////////////////////////
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Data dostawy',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(deliveryDate),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Magazyn',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  warehouse,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Pozycja magazynowa',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  warehousePosition,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Status',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Data kontroli',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(controlDate),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Rozmiar',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  size.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Data produkcji',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(productionDate),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                flex: 1, // Połowa szerokości dla każdej kolumny
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Autor ostatnich zmian',
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      modifiedByUser,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      softWrap: true, // Zawijanie tekstu
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 4, width: 16,),
              Flexible(
                flex: 1, // Połowa szerokości dla każdej kolumny
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Data ostatniej modyfikacji',
                      style: TextStyle(
                          color: Colors.grey, overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(lastModified),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      softWrap: true, // Zawijanie tekstu
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Dodany przez',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  createdByUser,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Data dodania',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(creationDate),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Data złomowania',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(scrappedAt),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              // Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              //   const Text(
              //     'Typ komponentów',
              //     style: TextStyle(color: Colors.grey),
              //   ),
              //   const SizedBox(height: 4),
              //   Text(
              //     componentType,
              //     style: const TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              // ]),
            ]),
          ],
        ),
      ),
    );
  }
}
