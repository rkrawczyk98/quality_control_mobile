import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_status_provider.dart';
import 'package:quality_control_mobile/src/views/widgets/components/component_info.dart';

class ComponentDetailsScreen extends StatefulWidget {
  final int componentId;

  const ComponentDetailsScreen({super.key, required this.componentId});

  @override
  ComponentDetailsScreenState createState() => ComponentDetailsScreenState();
}

class ComponentDetailsScreenState extends State<ComponentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ComponentSubcomponentProvider>(context, listen: false);
    provider.fetchSubcomponents();
  }

  @override
  Widget build(BuildContext context) {
    var subcomponentProvider =
        Provider.of<SubcomponentProvider>(context, listen: false);
    var componentProvider =
        Provider.of<ComponentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Komponentu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ComponentSubcomponentProvider>(
        builder: (context, provider, child) {
          var component = componentProvider.components
              .firstWhere((c) => c.id == widget.componentId);

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
                  status: component.status.name,
                  delivery: component.delivery.number,
                  deliveryDate: component.delivery.deliveryDate,
                  warehouse: component.warehouse.name,
                  warehousePosition: component.warehousePosition.name,
                  scrappedAt: component.scrappedAt,
                ),
                const SizedBox(height: 16),
                Text('Podkomponenty:',
                    style: Theme.of(context).textTheme.titleLarge),
                ...provider.componentsubcomponents
                    .where((subcomponent) =>
                        subcomponent.componentId == component.id)
                    .map((subcomponentInside) {
                  return ListTile(
                    leading: const Icon(Icons.extension),
                    title: Text(subcomponentProvider.subcomponents
                        .firstWhere((subcomp) =>
                            subcomp.id == subcomponentInside.subcomponentId)
                        .name),
                    subtitle: Consumer<SubcomponentStatusProvider>(
                      builder: (context, statusProvider, child) {
                        return Row(children: [
                          const Text('Status: '),
                          const SizedBox(width: 8),
                          DropdownButton<int>(
                            value: subcomponentInside.statusId,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                provider.updateSubcomponentStatus(
                                    subcomponentInside.id, newValue);
                              }
                            },
                            items: statusProvider.statuses.map((status) {
                              return DropdownMenuItem<int>(
                                value: status.id,
                                child: Text(status.name),
                              );
                            }).toList(),
                          )
                        ]);
                      },
                    ),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }
}
