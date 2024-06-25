import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/delivery_provider.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';
import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  final int deliveryId;

  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context) {
    // final DeliveryService deliveryService = DeliveryService();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Szczegóły Dostawy'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<DeliveryProvider>(context, listen: false)
                    .fetchDelivery(deliveryId);
              },
            ),
          ],
        ),
        body: Consumer<DeliveryProvider>(builder: (context, provider, child) {
          Delivery? delivery;
          try {
            delivery =
                provider.deliveries.firstWhere((d) => d.id == deliveryId);
          } catch (e) {
            delivery = null;
          }
          if (delivery == null) {
            return const Center(child: Text('Brak danych o dostawie.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DeliveryInfo(
                  number: delivery.number,
                  status: delivery.status.name,
                  statusDate: delivery.deliveryDate.toIso8601String(),
                  client: delivery.customer.name,
                  deliveryDate: formatDate(delivery.creationDate),
                  createdByUser: delivery.createdByUser.username,
                  componentType: delivery.componentType.name,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Historia dostawy',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: const [Text('Brak historii dostawy')],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

class DeliveryInfo extends StatelessWidget {
  final String number;
  final String status;
  final String statusDate;
  final String client;
  final String deliveryDate;
  final String createdByUser;
  final String componentType;

  const DeliveryInfo({
    super.key,
    required this.number,
    required this.status,
    required this.statusDate,
    required this.client,
    required this.deliveryDate,
    required this.createdByUser,
    required this.componentType,
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Nr dostawy',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text(
                  'Typ komponentów',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Klient',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client,
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
                    'Data dostawy',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deliveryDate,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Utworzono przez',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    createdByUser,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class DeliveryHistoryItem extends StatelessWidget {
  final String status;
  final String date;
  final IconData icon;
  final Color iconColor;

  const DeliveryHistoryItem({
    super.key,
    required this.status,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor),
            Container(
              width: 2,
              height: 50,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
