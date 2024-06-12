import 'package:quality_control_mobile/src/data/services/component_type_service.dart';
import 'package:quality_control_mobile/src/models/component_type_models.dart';

class ComponentTypeController {
  final ComponentTypeService _service = ComponentTypeService();

  Future<List<ComponentType>> getComponentTypes() async {
    return await _service.fetchComponentTypes();
  }

  Future<ComponentType> getComponentType(int id) async {
    return await _service.fetchComponentType(id);
  }

  Future<ComponentType> createComponentType(CreateComponentTypeDto dto) async {
    return await _service.createComponentType(dto);
  }

  Future<ComponentType> updateComponentType(int id, UpdateComponentTypeDto dto) async {
    return await _service.updateComponentType(id, dto);
  }

  Future<void> deleteComponentType(int id) async {
    await _service.deleteComponentType(id);
  }
}
