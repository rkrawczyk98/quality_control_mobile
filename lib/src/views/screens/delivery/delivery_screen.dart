import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/add_delivery_screen.dart';
import 'package:quality_control_mobile/src/data/services/delivery_service.dart';
import 'package:quality_control_mobile/src/views/screens/delivery/delivery_details_screen.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  DeliveryScreenState createState() => DeliveryScreenState();
}

class DeliveryScreenState extends State<DeliveryScreen> {
  late Future<List<Delivery>> futureDeliveries;
  final DeliveryService deliveryService = DeliveryService();

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() {
      futureDeliveries = deliveryService.fetchDeliveries();
    });
  }

  // ignore: unused_element
  void _refreshDeliveries() {
    setState(() {
      futureDeliveries = deliveryService.fetchDeliveries();
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
        ),
        child: TabBarView(
          children: [
            DeliveryList(futureDeliveries: futureDeliveries),
            const AddDeliveryScreen(),
          ],
        ),
      ),
    );
  }
}

class DeliveryList extends StatelessWidget {
  final Future<List<Delivery>> futureDeliveries;

  const DeliveryList({super.key, required this.futureDeliveries});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Delivery>>(
      future: futureDeliveries,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nie znaleziono żadnej dostawy.'));
        } else {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.map((delivery) {
              return PackageItem(
                delivery: delivery,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryDetailsScreen(
                        deliveryId: delivery.id,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class PackageItem extends StatelessWidget {
  final Delivery delivery;
  final VoidCallback onTap;

  const PackageItem({
    super.key,
    required this.delivery,
    required this.onTap,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                  delivery.deliveryDate.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                  child: const Text('Szczegóły'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}