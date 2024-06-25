import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/component_type_controller.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/component_type_models.dart';

class ComponentTypeProvider with ChangeNotifier {
  final ComponentTypeController _controller;

  ComponentTypeProvider(AuthProvider authProvider)
      : _controller = ComponentTypeController(authProvider) {
    fetchComponentTypes();
  }

  List<ComponentType> _componentTypes = [];

  List<ComponentType> get componentTypes => _componentTypes;

  // Pobieranie wszystkich typów komponentów
  Future<void> fetchComponentTypes() async {
    try {
      _componentTypes = await _controller.getComponentTypes();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch component types: $e");
    }
  }

  // Pobieranie pojedynczego typu komponentu
  Future<void> fetchComponentType(int id) async {
    try {
      ComponentType componentType = await _controller.getComponentType(id);
      int index = _componentTypes.indexWhere((ct) => ct.id == id);
      if (index != -1) {
        _componentTypes[index] = componentType;
      } else {
        _componentTypes.add(componentType);
      }
      notifyListeners();
    } catch (e) {
      print("Failed to fetch component type: $e");
    }
  }

  // Tworzenie nowego typu komponentu
  Future<void> createComponentType(CreateComponentTypeDto dto) async {
    try {
      ComponentType newType = await _controller.createComponentType(dto);
      _componentTypes.add(newType);
      notifyListeners();
    } catch (e) {
      print("Failed to create component type: $e");
    }
  }

  // Aktualizacja istniejącego typu komponentu
  Future<void> updateComponentType(int id, UpdateComponentTypeDto dto) async {
    try {
      ComponentType updatedType =
          await _controller.updateComponentType(id, dto);
      int index = _componentTypes.indexWhere((ct) => ct.id == id);
      if (index != -1) {
        _componentTypes[index] = updatedType;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update component type: $e");
    }
  }

  // Usuwanie typu komponentu
  Future<void> deleteComponentType(int id) async {
    try {
      await _controller.deleteComponentType(id);
      _componentTypes.removeWhere((type) => type.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete component type: $e");
    }
  }
}
