import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/component_controller.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';

class ComponentProvider with ChangeNotifier {
  final ComponentController _controller;

  ComponentProvider(AuthProvider authProvider)
      : _controller = ComponentController(authProvider) {
    fetchComponents();
  }

  List<Component> _components = [];
  Component? _currentComponent;

  List<Component> get components => _components;
  Component? get currentComponent => _currentComponent;

  Future<void> fetchComponents() async {
    try {
      _components = await _controller.getComponents();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch components: $e');
    }
  }

  Future<void> fetchComponentById(int id) async {
    try {
      _currentComponent = await _controller.getComponent(id);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch component: $e');
    }
  }

  Future<int> createComponent(CreateComponentDto dto) async {
    try {
      Component component = await _controller.createComponent(dto);
      _components.add(component);
      notifyListeners();
      return component.id;
    } catch (e) {
      throw('Failed to create component: $e');
    }
  }

  Future<void> deleteComponent(int id) async {
    try {
      await _controller.deleteComponent(id);
      _components.removeWhere((component) => component.id == id);
      notifyListeners();
    } catch (e) {
      print('Failed to delete component: $e');
    }
  }

  Future<void> fetchComponentsByDelivery(int deliveryId) async {
    try {
      _components = await _controller.getComponentsByDelivery(deliveryId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch components by delivery: $error');
    }
  }
}
