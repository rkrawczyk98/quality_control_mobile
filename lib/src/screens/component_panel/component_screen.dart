import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/services/component_service.dart';
import 'package:quality_control_mobile/src/widgets/scaffold_app.dart';
import 'package:quality_control_mobile/src/screens/component_panel/add_component_screen.dart';

class ComponentScreen extends StatefulWidget {
  const ComponentScreen({Key? key}) : super(key: key);

  @override
  _ComponentScreenState createState() => _ComponentScreenState();
}

class _ComponentScreenState extends State<ComponentScreen> {
  late Future<List<Component>> futureComponents;
  final ComponentService componentService = ComponentService();

  @override
  void initState() {
    super.initState();
    _loadComponents();
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
    return AppScaffold(
      title: 'Zarządzanie komponentami',
      tabs: const [
        Tab(text: 'Przeglądaj'),
        Tab(text: 'Utwórz'),
      ],
      children: [
        ComponentList(futureComponents: futureComponents),
        const AddComponentScreen(),
      ],
    );
  }
}

class ComponentList extends StatelessWidget {
  final Future<List<Component>> futureComponents;

  const ComponentList({Key? key, required this.futureComponents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Component>>(
      future: futureComponents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No components found'));
        } else {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.map((component) {
              return ComponentItem(
                component: component,
                onTap: () {
                  // Dodaj logikę przejścia do szczegółów komponentu, jeśli istnieje
                },
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class ComponentItem extends StatelessWidget {
  final Component component;
  final VoidCallback onTap;

  const ComponentItem({
    Key? key,
    required this.component,
    required this.onTap,
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
