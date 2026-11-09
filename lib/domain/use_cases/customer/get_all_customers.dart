import '../../entities/customer.dart';
import '../../../data/repositories/customer_repository_impl.dart';

class GetAllCustomers {
  final CustomerRepositoryImpl repository;

  GetAllCustomers(this.repository);

  List<Customer> execute() {
    return repository.getAllCustomers();
  }
}
