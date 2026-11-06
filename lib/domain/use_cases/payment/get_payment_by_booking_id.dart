import '../../entities/payment_record.dart';
import '../../../data/repositories/payment_repository_impl.dart';

class GetPaymentByBookingId {
  final PaymentRepositoryImpl paymentRepository;

  GetPaymentByBookingId({required this.paymentRepository});

  PaymentRecord? execute(int bookingId) {
    return paymentRepository.getPaymentByBookingId(bookingId);
  }
}
