import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_provider.dart';
import 'package:quality_control_mobile/src/data/providers/subcomponent_status_provider.dart';

class SubcomponentsList extends StatelessWidget {
  final int componentId;

  const SubcomponentsList({super.key, required this.componentId});

  @override
  Widget build(BuildContext context) {
    var subcomponentProvider = Provider.of<SubcomponentProvider>(context, listen: false);
    var subcomponentStatusProvider = Provider.of<SubcomponentStatusProvider>(context, listen: false);

    return Consumer<ComponentSubcomponentProvider>(
      builder: (context, provider, child) {
        var subcomponents = provider.componentsubcomponents.where((c) => c.componentId == componentId).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subcomponents.length,
          itemBuilder: (context, index) {
            var subcomponent = subcomponents[index];
            var subcomponentDetails = subcomponentProvider.subcomponents.firstWhere(
              (s) => s.id == subcomponent.subcomponentId,
              orElse: () => throw Exception('Nie znaleziono podkomponentów.'),
            );

            return ListTile(
              leading: const Icon(Icons.extension),
              title: Text(subcomponentDetails.name),
              subtitle: DropdownButton<int>(
                value: subcomponent.statusId,
                onChanged: (newValue) {
                  if (newValue != null) {
                    provider.updateSubcomponentStatus(subcomponent.subcomponentId, newValue);
                  }
                },
                items: subcomponentStatusProvider.statuses.map((status) {
                  return DropdownMenuItem<int>(
                    value: status.id,
                    child: Text(status.name),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
