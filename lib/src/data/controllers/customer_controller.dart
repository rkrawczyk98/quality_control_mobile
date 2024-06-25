import 'package:quality_control_mobile/src/data/providers/auth_provider.dart';
import 'package:quality_control_mobile/src/data/services/customer_service.dart';
import 'package:quality_control_mobile/src/models/customer_models.dart';

class CustomerController {
  final CustomerService _service;

  CustomerController(AuthProvider authProvider)
      : _service = CustomerService(authProvider);

  Future<List<Customer>> getCustomers() async {
    return await _service.fetchCustomers();
  }

  Future<Customer> getCustomer(int id) async {
    return await _service.fetchCustomer(id);
  }

  Future<Customer> createCustomer(CreateCustomerDto dto) async {
    return await _service.createCustomer(dto);
  }

  Future<Customer> updateCustomer(int id, UpdateCustomerDto dto) async {
    return await _service.updateCustomer(id, dto);
  }

  Future<void> deleteCustomer(int id) async {
    await _service.deleteCustomer(id);
  }
}
