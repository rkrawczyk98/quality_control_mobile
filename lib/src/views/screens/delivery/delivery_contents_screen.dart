import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_details_screen.dart';
import 'package:quality_control_mobile/src/views/screens/component/component_manage_screen.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';

class DeliveryContentsScreen extends StatelessWidget {
  final int deliveryId;

  const DeliveryContentsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComponentProvider>(context, listen: false)
          .fetchComponentsByDelivery(deliveryId);
    });

    return GlobalScaffold(
      appBar: AppBar(
        title: const Text('Zawartość Dostawy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Consumer<ComponentProvider>(
        builder: (context, provider, child) {
          if (provider.components.isEmpty) {
            return Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (const Center(
                    child: AutoSizeText(
                  'Brak komponentów dla wybranej dostawy',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ))),
                const SizedBox(
                  height: 18,
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.blue,
                      ),
                      tooltip: 'Kliknij aby dodać komponent do tej dostawy.',
                      onPressed: () => Navigator.pushNamed(
                          context, '/create-component-deliveryId',
                          arguments: deliveryId),
                    ),
                    const Text('Dodaj nowy komponent',
                        style: TextStyle(color: Colors.blue))
                  ],
                )
              ],
            ));
          }
          return ListView.builder(
              itemCount: provider.components.length,
              itemBuilder: (context, index) {
                final component = provider.components[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ComponentInfo(
                    id: component.id,
                    name: component.name,
                    controlDate: component.controlDate,
                    productionDate: component.productionDate,
                    size: component.size,
                    creationDate: component.creationDate,
                    lastModified: component.lastModified,
                    deletedAt: component.deletedAt,
                    createdByUser: component.createdByUser,
                    modifiedByUser: component.modifiedByUser,
                    componentType: component.componentType,
                    status: component.status.name,
                    delivery: component.delivery,
                    warehouse: component.warehouse,
                    warehousePosition: component.warehousePosition,
                    scrappedAt: component.scrappedAt,
                    onDetailsTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComponentDetailsScreen(
                            componentId: component.id,
                          ),
                        ),
                      )
                    },
                    onManageTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComponentManageScreen(
                            componentId: component.id,
                          ),
                        ),
                      )
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}

class ComponentInfo extends StatelessWidget {
  final int id;
  final String name;
  final DateTime? controlDate;
  final DateTime? productionDate;
  final double size;
  final DateTime creationDate;
  final DateTime lastModified;
  final DateTime? deletedAt;
  final User createdByUser;
  final User modifiedByUser;
  final String componentType;
  final String status;
  final Delivery delivery;
  final Warehouse warehouse;
  final WarehousePosition warehousePosition;
  final DateTime? scrappedAt;
  final VoidCallback onManageTap;
  final VoidCallback onDetailsTap;

  const ComponentInfo(
      {super.key,
      required this.name,
      required this.componentType,
      required this.status,
      required this.warehouse,
      required this.warehousePosition,
      required this.productionDate,
      required this.controlDate,
      required this.id,
      required this.size,
      required this.creationDate,
      required this.lastModified,
      required this.deletedAt,
      required this.createdByUser,
      required this.modifiedByUser,
      required this.delivery,
      required this.scrappedAt,
      required this.onManageTap,
      required this.onDetailsTap});

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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Numer komponentu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.view_in_ar,
                    color: Colors.green,
                    size: 35,
                  ),
                ],
              )
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
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
            ]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Magazyn',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      warehouse.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data kontroli',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(controlDate ?? DateTime.now()),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Pozycja magazynowa',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    warehousePosition.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed: onManageTap,
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                child: const Text('Zarządzaj'),
              ),
              TextButton(
                onPressed: onDetailsTap,
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                child: const Text('Szczegóły'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
