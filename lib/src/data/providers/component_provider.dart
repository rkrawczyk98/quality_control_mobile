import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/services/component_service.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';

class ComponentProvider with ChangeNotifier {
  final ComponentService _componentService = ComponentService();

  List<Component> _components = [];
  Component? _currentComponent;

  List<Component> get components => _components;
  Component? get currentComponent => _currentComponent;

  Future<void> fetchComponents() async {
    try {
      _components = await _componentService.fetchComponents();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch components: $e');
    }
  }

  Future<void> fetchComponentById(int id) async {
    try {
      _currentComponent = await _componentService.fetchComponent(id);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch component: $e');
    }
  }

  Future<void> createComponent(CreateComponentDto dto) async {
    try {
      Component component = await _componentService.createComponent(dto);
      _components.add(component);
      notifyListeners();
    } catch (e) {
      print('Failed to create component: $e');
    }
  }

  Future<void> deleteComponent(int id) async {
    try {
      await _componentService.deleteComponent(id);
      _components.removeWhere((component) => component.id == id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete component: $e');
    }
  }

  Future<void> fetchComponentsByDelivery(int deliveryId) async {
    try {
      _components =
          await _componentService.fetchComponentsByDelivery(deliveryId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch components by delivery: $error');
    }
  }
}
