import 'package:quality_control_mobile/src/data/services/customer_service.dart';
import 'package:quality_control_mobile/src/models/customer_models.dart';

class CustomerController {
  final CustomerService _customerService = CustomerService();

  Future<List<Customer>> getCustomers() async {
    return await _customerService.fetchCustomers();
  }

  Future<Customer> getCustomer(int id) async {
    return await _customerService.fetchCustomer(id);
  }

  Future<Customer> createCustomer(CreateCustomerDto dto) async {
    return await _customerService.createCustomer(dto);
  }

  Future<Customer> updateCustomer(int id, UpdateCustomerDto dto) async {
    return await _customerService.updateCustomer(id, dto);
  }

  Future<void> deleteCustomer(int id) async {
    await _customerService.deleteCustomer(id);
  }
}
