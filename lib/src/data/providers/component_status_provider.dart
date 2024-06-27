import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/component_status_controller.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/component_status_models.dart';

class ComponentStatusProvider with ChangeNotifier {
  final ComponentStatusController _controller;

  ComponentStatusProvider(AuthProvider authProvider)
      : _controller = ComponentStatusController(authProvider) {
    fetchComponentStatuses();
  }

  List<ComponentStatus> _statuses = [];

  List<ComponentStatus> get statuses => _statuses;

  Future<void> fetchComponentStatuses() async {
    try {
      _statuses = await _controller.getComponentStatuses();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch Component statuses: $e");
    }
  }

  Future<void> fetchComponentStatus(int id) async {
    try {
      ComponentStatus status = await _controller.getComponentStatus(id);
      int index = _statuses.indexWhere((s) => s.id == id);
      if (index != -1) {
        _statuses[index] = status;
      } else {
        _statuses.add(status);
      }
      notifyListeners();
    } catch (e) {
      print("Failed to fetch Component status: $e");
    }
  }

  Future<void> createComponentStatus(CreateComponentStatusDto dto) async {
    try {
      ComponentStatus newStatus = await _controller.createComponentStatus(dto);
      _statuses.add(newStatus);
      notifyListeners();
    } catch (e) {
      print("Failed to create Component status: $e");
    }
  }

  Future<void> deleteComponentStatus(int id) async {
    try {
      await _controller.deleteComponentStatus(id);
      _statuses.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete Component status: $e");
    }
  }

  Future<void> updateComponentStatus(
      int id, UpdateComponentStatusDto dto) async {
    try {
      ComponentStatus updatedStatus =
          await _controller.updateComponentStatus(id, dto);
      int index = _statuses.indexWhere((s) => s.id == id);
      if (index != -1) {
        _statuses[index] = updatedStatus;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update Component status: $e");
    }
  }
}
