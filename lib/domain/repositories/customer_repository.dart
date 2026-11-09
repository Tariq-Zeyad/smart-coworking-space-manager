import '../entities/customer.dart';

abstract class CustomerRepository {
  void addCustomer(Customer customer);

  Customer? getCustomerById(int customerId);

  List<Customer> getAllCustomers();

  Customer? getCustomerByPhone(String phoneNumber);

  void updateCustomer(Customer customer);

  void deleteCustomer(int customerId);
}
