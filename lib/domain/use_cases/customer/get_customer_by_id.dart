import '../../entities/customer.dart';
import '../../../data/repositories/customer_repository_impl.dart';

class GetCustomerById {
  final CustomerRepositoryImpl repository;

  GetCustomerById(this.repository);

  Customer? execute(int customerId) {
    return repository.getCustomerById(customerId);
  }
}
