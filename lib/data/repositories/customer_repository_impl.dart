import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../data_sources/local/customer_local_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource dataSource;

  CustomerRepositoryImpl({required this.dataSource});

  @override
  void addCustomer(Customer customer) {
    dataSource.addCustomer(customer);
  }

  @override
  Customer? getCustomerById(int customerId) {
    return dataSource.getCustomerById(customerId);
  }

  @override
  List<Customer> getAllCustomers() {
    return dataSource.getAllCustomers();
  }

  @override
  Customer? getCustomerByPhone(String phoneNumber) {
    return dataSource.getCustomerByPhone(phoneNumber);
  }

  @override
  void updateCustomer(Customer customer) {
    dataSource.updateCustomer(customer);
  }

  @override
  void deleteCustomer(int customerId) {
    dataSource.deleteCustomer(customerId);
  }
}
