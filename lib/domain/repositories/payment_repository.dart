import '../entities/payment_record.dart';

abstract class PaymentRepository {
  void addPayment(PaymentRecord payment);

  PaymentRecord? getPaymentById(int paymentId);

  PaymentRecord? getPaymentByBookingId(int bookingId);

  List<PaymentRecord> getAllPayments();
}
