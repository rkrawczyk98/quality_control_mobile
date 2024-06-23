import 'package:quality_control_mobile/src/data/services/component_subcomponent_service.dart';
import 'package:quality_control_mobile/src/models/component_subcomponent_models.dart';

class ComponentSubcomponentController {
  final ComponentSubcomponentService _service = ComponentSubcomponentService();

  Future<List<ComponentSubcomponent>> getComponentSubcomponents() async {
    return await _service.fetchComponentSubcomponents();
  }

  Future<ComponentSubcomponent> getComponentSubcomponent(int id) async {
    return await _service.fetchComponentSubcomponent(id);
  }

  Future<ComponentSubcomponent> createComponentSubcomponent(
      CreateComponentSubcomponentDto dto) async {
    return await _service.createComponentSubcomponent(dto);
  }

  Future<void> deleteComponentSubcomponent(int id) async {
    await _service.deleteComponentSubcomponent(id);
  }

  Future<ComponentSubcomponent> updateComponentSubcomponent(
      int id, UpdateComponentSubcomponentDto dto) async {
    return await _service.updateComponentSubcomponent(id, dto);
  }

  Future<void> updateSubcomponentStatus(
      int subcomponentId, int newStatusId) async {
    UpdateComponentSubcomponentDto dto =
        UpdateComponentSubcomponentDto(statusId: newStatusId);
    await _service.updateComponentSubcomponent(subcomponentId, dto);
  }
}
