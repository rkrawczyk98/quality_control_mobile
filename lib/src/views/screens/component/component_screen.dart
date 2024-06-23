import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/data/services/component_service.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/views/widgets/global_scaffold.dart';
import 'package:quality_control_mobile/src/views/screens/component/add_component_screen.dart';

class ComponentScreen extends StatefulWidget {
  const ComponentScreen({super.key});

  @override
  ComponentScreenState createState() => ComponentScreenState();
}

class ComponentScreenState extends State<ComponentScreen> {
  late Future<List<Component>> futureComponents;
  final ComponentService componentService = ComponentService();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ComponentProvider>(context, listen: false);
    provider.fetchComponents();
  }

  Future<void> _loadComponents() async {
    setState(() {
      futureComponents = componentService.fetchComponents();
    });
  }

  void _refreshComponents() {
    setState(() {
      futureComponents = componentService.fetchComponents();
    });
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

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       title: 'Zarządzanie komponentami',
//       tabs: const [
//         Tab(text: 'Przeglądaj'),
//         Tab(text: 'Utwórz'),
//       ],
//       children: [
//         ComponentList(futureComponents: futureComponents),
//         const AddComponentScreen(),
//       ],
//     );
//   }
// }

class ComponentList extends StatelessWidget {
  const ComponentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComponentProvider>(
      builder: (context, provider, child) {
        if (provider.components.isEmpty) {
          return const Center(child: Text('No components found'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: provider.components.map((component) {
            return ComponentItem(
              component: component,
              onTap: () {
                // Dodaj logikę przejścia do szczegółów komponentu, jeśli istnieje
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class ComponentItem extends StatelessWidget {
  final Component component;
  final VoidCallback onTap;

  const ComponentItem({
    super.key,
    required this.component,
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
              'Nazwa komponentu',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              component.name,
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
                  'Data kontroli',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  component.controlDate?.toString() ?? 'Brak',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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