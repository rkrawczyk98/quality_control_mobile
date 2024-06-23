import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/subcomponent_status_controller.dart';
import 'package:quality_control_mobile/src/models/subcomponent_status_models.dart';

class SubcomponentStatusProvider with ChangeNotifier {
  final SubcomponentStatusController _controller = SubcomponentStatusController();

  List<SubcomponentStatus> _statuses = [];

  List<SubcomponentStatus> get statuses => _statuses;

  // Pobieranie wszystkich statusów podkomponentów
  Future<void> fetchSubcomponentStatuses() async {
    try {
      _statuses = await _controller.getSubcomponentStatuses();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch subcomponent statuses: $e");
    }
  }

  // Pobieranie pojedynczego statusu podkomponentu
  Future<void> fetchSubcomponentStatus(int id) async {
    try {
      SubcomponentStatus status = await _controller.getSubcomponentStatus(id);
      int index = _statuses.indexWhere((s) => s.id == id);
      if (index != -1) {
        _statuses[index] = status;
      } else {
        _statuses.add(status);
      }
      notifyListeners();
    } catch (e) {
      print("Failed to fetch subcomponent status: $e");
    }
  }

  // Tworzenie nowego statusu podkomponentu
  Future<void> createSubcomponentStatus(CreateSubcomponentStatusDto dto) async {
    try {
      SubcomponentStatus newStatus = await _controller.createSubcomponentStatus(dto);
      _statuses.add(newStatus);
      notifyListeners();
    } catch (e) {
      print("Failed to create subcomponent status: $e");
    }
  }

  // Usuwanie statusu podkomponentu
  Future<void> deleteSubcomponentStatus(int id) async {
    try {
      await _controller.deleteSubcomponentStatus(id);
      _statuses.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete subcomponent status: $e");
    }
  }

  // Aktualizacja istniejącego statusu podkomponentu
  Future<void> updateSubcomponentStatus(int id, UpdateSubcomponentStatusDto dto) async {
    try {
      SubcomponentStatus updatedStatus = await _controller.updateSubcomponentStatus(id, dto);
      int index = _statuses.indexWhere((s) => s.id == id);
      if (index != -1) {
        _statuses[index] = updatedStatus;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update subcomponent status: $e");
    }
  }
}
