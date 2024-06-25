import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/subcomponent_controller.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/subcomponent_models.dart';

class SubcomponentProvider with ChangeNotifier {
  final SubcomponentController _controller;

  SubcomponentProvider(AuthProvider authProvider) : _controller = SubcomponentController(authProvider) {
    fetchSubcomponents();
  }

  List<Subcomponent> _subcomponents = [];

  List<Subcomponent> get subcomponents => _subcomponents;

  Future<void> fetchSubcomponents() async {
    try {
      _subcomponents = await _controller.getSubcomponents();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch subcomponents: $e");
    }
  }

  Future<void> fetchSubcomponent(int id) async {
    try {
      Subcomponent subcomponent = await _controller.getSubcomponent(id);
      int index = _subcomponents.indexWhere((s) => s.id == id);
      if (index != -1) {
        _subcomponents[index] = subcomponent;
      } else {
        _subcomponents.add(subcomponent);
      }
      notifyListeners();
    } catch (e) {
      print("Failed to fetch subcomponent: $e");
    }
  }

  Future<void> createSubcomponent(CreateSubcomponentDto dto) async {
    try {
      Subcomponent newSubcomponent = await _controller.createSubcomponent(dto);
      _subcomponents.add(newSubcomponent);
      notifyListeners();
    } catch (e) {
      print("Failed to create subcomponent: $e");
    }
  }

  Future<void> updateSubcomponent(int id, UpdateSubcomponentDto dto) async {
    try {
      Subcomponent updatedSubcomponent = await _controller.updateSubcomponent(id, dto);
      int index = _subcomponents.indexWhere((s) => s.id == id);
      if (index != -1) {
        _subcomponents[index] = updatedSubcomponent;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update subcomponent: $e");
    }
  }

  Future<void> deleteSubcomponent(int id) async {
    try {
      await _controller.deleteSubcomponent(id);
      _subcomponents.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete subcomponent: $e");
    }
  }
}
