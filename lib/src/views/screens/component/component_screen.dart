import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';
import 'package:quality_control_mobile/src/views/screens/component/add_component_screen.dart';

class ComponentScreen extends StatefulWidget {
  const ComponentScreen({super.key});

  @override
  ComponentScreenState createState() => ComponentScreenState();
}

class ComponentScreenState extends State<ComponentScreen> {
  late Future<List<Component>> futureComponents;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ComponentProvider>(context, listen: false);
    provider.fetchComponents();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GlobalScaffold(
        appBar: AppBar(
          title: const Text('Zarządzanie komponentami'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Przeglądaj'),
              Tab(text: 'Utwórz'),
            ],
          ),
        ),
        child: const TabBarView(
          children: [
            ComponentList(),
            AddComponentScreen(),
          ],
        ),
      ),
    );
  }
}

class ComponentList extends StatelessWidget {
  const ComponentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComponentProvider>(
      builder: (context, provider, child) {
        if (provider.components.isEmpty) {
          return const Center(
              child: Text('Nie znaleziono żadnych komponentów.'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: provider.components.map((component) {
            return ComponentItem(
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
              onDetailsTap: () => Navigator.pushNamed(
                  context, '/component-details',
                  arguments: component.id),
              onManageTap: () => Navigator.pushNamed(
                  context, '/component-manage',
                  arguments: component.id),
            );
          }).toList(),
        );
      },
    );
  }
}

class ComponentItem extends StatelessWidget {
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
  final VoidCallback onDetailsTap;
  final VoidCallback onManageTap;

  const ComponentItem({
    super.key,
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
    required this.onDetailsTap,
    required this.onManageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              const Text(
                'Numer dostawy',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                delivery.number,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ]),
            const Divider(color: Colors.white),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: Column(
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
              )),
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
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  ])),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                  ])),
            ]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
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
                )),
              ],
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: Column(
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )),
              Expanded(
                  child: Column(
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
              )),
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
        )),
      ),
    );
  }
}
