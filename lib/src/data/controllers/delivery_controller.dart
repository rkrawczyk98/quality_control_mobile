import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/delivery_service.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';

class DeliveryController {
  final DeliveryService _service;

  DeliveryController(AuthProvider authProvider)
      : _service = DeliveryService(authProvider);

  Future<List<Delivery>> getDeliveries() async {
    return await _service.fetchDeliveries();
  }

  Future<Delivery> getDelivery(int id) async {
    return await _service.fetchDelivery(id);
  }

  Future<Delivery> createDelivery(CreateDeliveryDto createDeliveryDto) async {
    return await _service.createDelivery(createDeliveryDto);
  }

  Future<void> deleteDelivery(int id) async {
    await _service.deleteDelivery(id);
  }
}
