import '../../../domain/entities/customer.dart';

class CustomerLocalDataSource {
  final Map<int, Customer> _customers = {};

  void addCustomer(Customer customer) {
    _customers[customer.customerId] = customer;
  }

  Customer? getCustomerById(int customerId) {
    return _customers[customerId];
  }

  List<Customer> getAllCustomers() {
    return _customers.values.toList();
  }

  Customer? getCustomerByPhone(String phoneNumber) {
    for (final customer in _customers.values) {
      if (customer.phoneNumber == phoneNumber) {
        return customer;
      }
    }
    return null;
  }

  void updateCustomer(Customer customer) {
    if (_customers.containsKey(customer.customerId)) {
      _customers[customer.customerId] = customer;
    }
  }

  void deleteCustomer(int customerId) {
    _customers.remove(customerId);
  }
}
