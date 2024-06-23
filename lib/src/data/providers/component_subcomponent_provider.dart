import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/component_subcomponent_controller.dart';
import 'package:quality_control_mobile/src/models/component_subcomponent_models.dart';

class ComponentSubcomponentProvider with ChangeNotifier {
  final ComponentSubcomponentController _controller = ComponentSubcomponentController();

  List<ComponentSubcomponent> _subcomponents = [];

  List<ComponentSubcomponent> get subcomponents => _subcomponents;

  Future<void> fetchSubcomponents() async {
    try {
      _subcomponents = await _controller.getComponentSubcomponents();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch subcomponents: $e");
    }
  }

Future<void> fetchSubcomponentById(int id) async {
  try {
    // Pobierz subkomponent i zaktualizuj listę lub pojedynczy subkomponent
    var subcomponent = await _controller.getComponentSubcomponent(id);
    int index = _subcomponents.indexWhere((item) => item.id == id);
    if (index != -1) {
      // Aktualizuje istniejący subkomponent
      _subcomponents[index] = subcomponent;
    } else {
      // Dodaje nowy jeśli to nowe dane
      _subcomponents.add(subcomponent);
    }
    notifyListeners();
  } catch (e) {
    print("Failed to fetch subcomponent: $e");
  }
}

  Future<void> createSubcomponent(CreateComponentSubcomponentDto dto) async {
    try {
      var newSubcomponent = await _controller.createComponentSubcomponent(dto);
      _subcomponents.add(newSubcomponent);
      notifyListeners();
    } catch (e) {
      print("Failed to create subcomponent: $e");
    }
  }

  Future<void> deleteSubcomponent(int id) async {
    try {
      await _controller.deleteComponentSubcomponent(id);
      _subcomponents.removeWhere((subcomponent) => subcomponent.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete subcomponent: $e");
    }
  }

  Future<void> updateSubcomponentStatus(int subcomponentId, int newStatusId) async {
    try {
      await _controller.updateSubcomponentStatus(subcomponentId, newStatusId);
      var index = _subcomponents.indexWhere((sub) => sub.id == subcomponentId);
      if (index != -1) {
        _subcomponents[index].statusId = newStatusId;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update subcomponent status: $e");
    }
  }
}
