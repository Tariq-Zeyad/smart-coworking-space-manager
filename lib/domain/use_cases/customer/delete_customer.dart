import '../../../data/repositories/customer_repository_impl.dart';
import '../../../core/errors/app_exceptions.dart';

class DeleteCustomer {
  final CustomerRepositoryImpl repository;

  DeleteCustomer(this.repository);

  void execute(int customerId) {
    final customer = repository.getCustomerById(customerId);

    if (customer == null) {
      throw const NotFoundException('Customer not found.');
    }

    repository.deleteCustomer(customerId);
  }
}
