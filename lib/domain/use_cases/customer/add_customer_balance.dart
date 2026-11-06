import '../../repositories/customer_repository.dart';
import '../../../core/errors/app_exceptions.dart';

class AddCustomerBalance {
  final CustomerRepository repository;

  AddCustomerBalance(this.repository);

  void execute(int customerId, double amount) {
    final customer = repository.getCustomerById(customerId);

    if (customer == null) {
      throw const NotFoundException('Customer not found.');
    }

    customer.addBalance(amount);

    repository.updateCustomer(customer);
  }
}
