import 'package:quality_control_mobile/src/data/services/delivery_service.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';

class DeliveryController {
  final DeliveryService service = DeliveryService();

  Future<List<Delivery>> getDeliveries() async {
    return await service.fetchDeliveries();
  }

  Future<Delivery> getDelivery(int id) async {
    return await service.fetchDelivery(id);
  }

  Future<Delivery> createDelivery(CreateDeliveryDto createDeliveryDto) async {
    return await service.createDelivery(createDeliveryDto);
  }

  Future<void> deleteDelivery(int id) async {
    await service.deleteDelivery(id);
  }
}
