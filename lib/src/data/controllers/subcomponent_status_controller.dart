import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/subcomponent_status_service.dart';
import 'package:quality_control_mobile/src/models/subcomponent_status_models.dart';

class SubcomponentStatusController {
  final SubcomponentStatusService _service;

  SubcomponentStatusController(AuthProvider authProvider)
      : _service = SubcomponentStatusService(authProvider);

  Future<List<SubcomponentStatus>> getSubcomponentStatuses() async {
    return await _service.fetchSubcomponentStatuses();
  }

  Future<SubcomponentStatus> getSubcomponentStatus(int id) async {
    return await _service.fetchSubcomponentStatus(id);
  }

  Future<SubcomponentStatus> createSubcomponentStatus(CreateSubcomponentStatusDto dto) async {
    return await _service.createSubcomponentStatus(dto);
  }

  Future<void> deleteSubcomponentStatus(int id) async {
    await _service.deleteSubcomponentStatus(id);
  }

  Future<SubcomponentStatus> updateSubcomponentStatus(int id, UpdateSubcomponentStatusDto dto) async {
    return await _service.updateSubcomponentStatus(id, dto);
  }
}
