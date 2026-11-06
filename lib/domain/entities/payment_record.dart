import '../../core/errors/app_exceptions.dart';

import 'booking.dart';

class PaymentRecord {
  final int paymentId;

  final Booking booking;

  final double amount;

  final DateTime paymentDate;

  final String paymentMethod;

  PaymentRecord({
    required this.paymentId,
    required this.booking,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
  }) {
    if (paymentId <= 0) {
      throw const ValidationException('Payment ID must be positive');
    }

    if (!amount.isFinite || amount <= 0) {
      throw const ValidationException(
        'Payment amount must be greater than zero',
      );
    }

    if (amount != booking.totalCost) {
      throw const ValidationException(
        'Payment amount must equal booking total cost',
      );
    }

    if (paymentMethod.trim().isEmpty) {
      throw const ValidationException('Payment method cannot be empty');
    }
  }
}
