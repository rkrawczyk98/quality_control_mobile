import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';
class ComponentManageScreen extends StatelessWidget {
  final int componentId;

  const ComponentManageScreen({super.key, required this.componentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Komponentu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ComponentProvider>(
        builder: (context, provider, child) {
          var component =
              provider.components.firstWhere((c) => c.id == componentId);
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
              ],
            ),
          );
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



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quality_control_mobile/src/data/providers/component_provider.dart';
// import 'package:quality_control_mobile/src/data/providers/component_subcomponent_provider.dart';
// import 'package:quality_control_mobile/src/data/providers/subcomponent_status_provider.dart';
// import 'package:quality_control_mobile/src/models/component_models.dart';
// import 'package:quality_control_mobile/src/utils/formatters/date_formater.dart';

// class ComponentManageScreen extends StatelessWidget {
//   final int componentId;

//   const ComponentManageScreen({super.key, required this.componentId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Szczegóły Komponentu'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Consumer<ComponentProvider>(
//         builder: (context, provider, child) {
//           var component =
//               provider.components.firstWhere((c) => c.id == componentId);
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ComponentInfo(component: component),
//                 const SizedBox(height: 16),
//                 Text('Podkomponenty:',
//                     style: Theme.of(context).textTheme.titleLarge),
//                 ...component.subcomponents.map((subcomponent) => ListTile(
//                       leading: const Icon(Icons.extension),
//                       title: Text(subcomponent.name),
//                       subtitle: Consumer<SubcomponentStatusProvider>(
//                         builder: (context, statusProvider, child) {
//                           var status = statusProvider.statuses
//                               .firstWhere((s) => s.id == subcomponent.id);
//                           return DropdownButton<int>(
//                             value: status.id,
//                             onChanged: (newValue) {
//                               if (newValue != null) {
//                                 var subcomponentProvider =
//                                     Provider.of<ComponentSubcomponentProvider>(
//                                         context,
//                                         listen: false);
//                                 subcomponentProvider.updateSubcomponentStatus(
//                                     subcomponent.id, newValue);
//                               }
//                             },
//                             items: statusProvider.statuses.map((status) {
//                               return DropdownMenuItem<int>(
//                                 value: status.id,
//                                 child: Text(status.name),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       ),
//                     ))
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ComponentInfo extends StatelessWidget {
//   final Component component;

//   const ComponentInfo({super.key, required this.component});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey[850],
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Nazwa: ${component.name}',
//                 style: const TextStyle(color: Colors.white)),
//             Text('Typ: ${component.componentType}',
//                 style: const TextStyle(color: Colors.white)),
//             Text('Status: ${component.status}',
//                 style: const TextStyle(color: Colors.white)),
//             Text('Data kontroli: ${formatDate(component.controlDate)}',
//                 style: const TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }
