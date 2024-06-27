import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/delivery_provider.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';
import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/add_delivery_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_contents_screen.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_details_screen.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  DeliveryScreenState createState() => DeliveryScreenState();
}

class DeliveryScreenState extends State<DeliveryScreen> {
  late Future<List<Delivery>> futureDeliveries;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DeliveryProvider>(context, listen: false).fetchDeliveries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Dla dwóch zakładek
      child: GlobalScaffold(
        appBar: AppBar(
          title: const Text('Zarządzanie dostawami'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Przeglądaj'),
              Tab(text: 'Utwórz'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  Provider.of<DeliveryProvider>(context, listen: false)
                      .fetchDeliveries(),
            ),
          ],
        ),
        child: TabBarView(
          children: [
            Consumer<DeliveryProvider>(
              builder: (context, provider, child) {
                return DeliveryList(deliveries: provider.deliveries);
              },
            ),
            const AddDeliveryScreen(),
          ],
        ),
      ),
    );
  }
}

class DeliveryList extends StatelessWidget {
  final List<Delivery> deliveries;

  const DeliveryList({super.key, required this.deliveries});

  @override
  Widget build(BuildContext context) {
    if (deliveries.isEmpty) {
      return const Center(child: Text('Nie znaleziono żadnej dostawy.'));
    } else {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: deliveries.map((delivery) {
          return PackageItem(
            delivery: delivery,
            onDetailsTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryDetailsScreen(
                    deliveryId: delivery.id,
                  ),
                ),
              );
            },
            onContentTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryContentsScreen(
                    deliveryId: delivery.id,
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    }
  }
}

class PackageItem extends StatelessWidget {
  final Delivery delivery;
  final VoidCallback onContentTap;
  final VoidCallback onDetailsTap;

  const PackageItem({
    super.key,
    required this.delivery,
    required this.onContentTap,
    required this.onDetailsTap,
  });

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
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Numer dostawy',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    delivery.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
              const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.green,
                  size: 30,
                ),
              ]),
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
                        'Typ komponentu',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        delivery.componentType.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                      Text(
                        delivery.status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]))
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Klient',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      delivery.customer.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      const Text(
                        'Ostatnia zmiana',
                        style: TextStyle(color: Colors.grey),
                      ),
                      AutoSizeText(
                        formatDate(delivery.lastModified),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ]))
              ],
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed: onContentTap,
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                child: const Text('Zawartość'),
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
