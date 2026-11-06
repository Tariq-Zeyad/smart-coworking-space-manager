import '../../domain/entities/payment_record.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_sources/local/payment_local_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource dataSource;

  PaymentRepositoryImpl({required this.dataSource});

  @override
  void addPayment(PaymentRecord payment) {
    dataSource.addPayment(payment);
  }

  @override
  PaymentRecord? getPaymentById(int paymentId) {
    return dataSource.getPaymentById(paymentId);
  }

  @override
  PaymentRecord? getPaymentByBookingId(int bookingId) {
    return dataSource.getPaymentByBookingId(bookingId);
  }

  @override
  List<PaymentRecord> getAllPayments() {
    return dataSource.getAllPayments();
  }
}
