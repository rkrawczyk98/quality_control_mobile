import 'package:flutter/material.dart';
import 'package:quality_control_mobile/src/data/controllers/customer_controller.dart';
import 'package:quality_control_mobile/src/models/customer_models.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerController _controller = CustomerController();

  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  // Pobieranie wszystkich klientów
  Future<void> fetchCustomers() async {
    try {
      _customers = await _controller.getCustomers();
      notifyListeners();
    } catch (e) {
      print("Failed to fetch customers: $e");
    }
  }

  // Pobieranie pojedynczego klienta
  Future<void> fetchCustomer(int id) async {
    try {
      Customer customer = await _controller.getCustomer(id);
      int index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = customer;
      } else {
        _customers.add(customer);
      }
      notifyListeners();
    } catch (e) {
      print("Failed to fetch customer: $e");
    }
  }

  // Tworzenie nowego klienta
  Future<void> createCustomer(CreateCustomerDto dto) async {
    try {
      Customer newCustomer = await _controller.createCustomer(dto);
      _customers.add(newCustomer);
      notifyListeners();
    } catch (e) {
      print("Failed to create customer: $e");
    }
  }

  // Aktualizacja istniejącego klienta
  Future<void> updateCustomer(int id, UpdateCustomerDto dto) async {
    try {
      Customer updatedCustomer = await _controller.updateCustomer(id, dto);
      int index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = updatedCustomer;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to update customer: $e");
    }
  }

  // Usuwanie klienta
  Future<void> deleteCustomer(int id) async {
    try {
      await _controller.deleteCustomer(id);
      _customers.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete customer: $e");
    }
  }
}
