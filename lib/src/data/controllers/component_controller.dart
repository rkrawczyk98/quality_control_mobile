import 'package:quality_control_mobile/src/data/services/component_service.dart';
import 'package:quality_control_mobile/src/models/component_models.dart';

class ComponentController {
  final ComponentService _service = ComponentService();

  Future<List<Component>> getComponents() async {
    return await _service.fetchComponents();
  }

  Future<Component> getComponent(int id) async {
    return await _service.fetchComponent(id);
  }

  Future<Component> createComponent(CreateComponentDto dto) async {
    return await _service.createComponent(dto);
  }

  Future<void> deleteComponent(int id) async {
    await _service.deleteComponent(id);
  }
}
