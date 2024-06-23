import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/delivery_controller.dart';
import 'package:quality_control_mobile/src/models/delivery_models.dart';

class DeliveryProvider with ChangeNotifier {
  final DeliveryController _controller = DeliveryController();

  List<Delivery> _deliveries = [];

  List<Delivery> get deliveries => _deliveries;

  // Pobieranie wszystkich dostaw
  Future<void> fetchDeliveries() async {
    try {
      _deliveries = await _controller.getDeliveries();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch deliveries: $e");
    }
  }

  // Pobieranie pojedynczej dostawy
  Future<void> fetchDelivery(int id) async {
    try {
      Delivery delivery = await _controller.getDelivery(id);
      int index = _deliveries.indexWhere((d) => d.id == id);
      if (index != -1) {
        _deliveries[index] = delivery;
      } else {
        _deliveries.add(delivery);
      }
      notifyListeners();
    } catch (e) {
      print("Failed to fetch delivery: $e");
    }
  }

  // Tworzenie nowej dostawy
  Future<void> createDelivery(CreateDeliveryDto dto) async {
    try {
      Delivery newDelivery = await _controller.createDelivery(dto);
      _deliveries.add(newDelivery);
      notifyListeners();
    } catch (e) {
      print("Failed to create delivery: $e");
    }
  }

  // Aktualizacja istniejącej dostawy
  Future<void> updateDelivery(int id, CreateDeliveryDto dto) async {
    try {
      Delivery updatedDelivery = await _controller.createDelivery(dto);  // assuming a similar method signature
      int index = _deliveries.indexWhere((d) => d.id == id);
      if (index != -1) {
        _deliveries[index] = updatedDelivery;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update delivery: $e");
    }
  }

  // Usuwanie dostawy
  Future<void> deleteDelivery(int id) async {
    try {
      await _controller.deleteDelivery(id);
      _deliveries.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete delivery: $e");
    }
  }
}
