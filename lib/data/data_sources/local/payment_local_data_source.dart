import '../../../domain/entities/payment_record.dart';

class PaymentLocalDataSource {
  final Map<int, PaymentRecord> _payments = {};

  void addPayment(PaymentRecord payment) {
    _payments[payment.paymentId] = payment;
  }

  PaymentRecord? getPaymentById(int paymentId) {
    return _payments[paymentId];
  }

  PaymentRecord? getPaymentByBookingId(int bookingId) {
    for (final payment in _payments.values) {
      if (payment.booking.bookingId == bookingId) {
        return payment;
      }
    }

    return null;
  }

  List<PaymentRecord> getAllPayments() {
    return _payments.values.toList();
  }
}
