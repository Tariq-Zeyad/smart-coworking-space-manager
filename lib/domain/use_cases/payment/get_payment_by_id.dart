import '../../entities/payment_record.dart';
import '../../../data/repositories/payment_repository_impl.dart';

class GetPaymentById {
  final PaymentRepositoryImpl paymentRepository;

  GetPaymentById({required this.paymentRepository});

  PaymentRecord? execute(int paymentId) {
    return paymentRepository.getPaymentById(paymentId);
  }
}
