import '../../entities/customer.dart';
import '../../../data/repositories/customer_repository_impl.dart';
import '../../../core/errors/app_exceptions.dart';

class AddCustomer {
  final CustomerRepositoryImpl repository;

  AddCustomer(this.repository);

  void execute(Customer customer) {
    final existingCustomer = repository.getCustomerById(customer.customerId);

    if (existingCustomer != null) {
      throw const ValidationException('Customer ID already exists.');
    }

    final existingPhone = repository.getCustomerByPhone(customer.phoneNumber);

    if (existingPhone != null) {
      throw const ValidationException('Phone number already exists.');
    }

    repository.addCustomer(customer);
  }
}
