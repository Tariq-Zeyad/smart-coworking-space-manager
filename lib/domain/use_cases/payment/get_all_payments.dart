import '../../entities/payment_record.dart';
import '../../../data/repositories/payment_repository_impl.dart';

class GetAllPayments {
  final PaymentRepositoryImpl paymentRepository;

  GetAllPayments({required this.paymentRepository});

  List<PaymentRecord> execute() {
    return paymentRepository.getAllPayments();
  }
}
