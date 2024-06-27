import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/component_status_service.dart';
import 'package:quality_control_mobile/src/models/component_status_models.dart';

class ComponentStatusController {
  final ComponentStatusService _service;

  ComponentStatusController(AuthProvider authProvider)
      : _service = ComponentStatusService(authProvider);

  Future<List<ComponentStatus>> getComponentStatuses() async {
    return await _service.fetchComponentStatuses();
  }

  Future<ComponentStatus> getComponentStatus(int id) async {
    return await _service.fetchComponentStatus(id);
  }

  Future<ComponentStatus> createComponentStatus(CreateComponentStatusDto dto) async {
    return await _service.createComponentStatus(dto);
  }

  Future<void> deleteComponentStatus(int id) async {
    await _service.deleteComponentStatus(id);
  }

  Future<ComponentStatus> updateComponentStatus(int id, UpdateComponentStatusDto dto) async {
    return await _service.updateComponentStatus(id, dto);
  }
}
