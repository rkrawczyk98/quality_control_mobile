import 'package:quality_control_mobile/src/data/services/subcomponent_service.dart';
import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/models/subcomponent_models.dart';

class SubcomponentController {
  final SubcomponentService _service;

  SubcomponentController(AuthProvider authProvider) : _service = SubcomponentService(authProvider);

  Future<List<Subcomponent>> getSubcomponents() async {
    return await _service.fetchSubcomponents();
  }

  Future<Subcomponent> getSubcomponent(int id) async {
    return await _service.fetchSubcomponent(id);
  }

  Future<Subcomponent> createSubcomponent(CreateSubcomponentDto dto) async {
    return await _service.createSubcomponent(dto);
  }

  Future<Subcomponent> updateSubcomponent(int id, UpdateSubcomponentDto dto) async {
    return await _service.updateSubcomponent(id, dto);
  }

  Future<void> deleteSubcomponent(int id) async {
    await _service.deleteSubcomponent(id);
  }
}
