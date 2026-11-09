import '../../entities/payment_record.dart';
import '../../repositories/booking_repository.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/payment_repository.dart';

import '../../enums/payment_status.dart';
import '../../enums/booking_status.dart';

import '../../../core/errors/app_exceptions.dart';

class RecordPayment {
  final BookingRepository bookingRepository;
  final PaymentRepository paymentRepository;
  final CustomerRepository customerRepository;

  RecordPayment({
    required this.bookingRepository,
    required this.paymentRepository,
    required this.customerRepository,
  });

  void execute({
    required int paymentId,
    required int bookingId,
    required String paymentMethod,
    required DateTime paymentDate,
  }) {
    // ---- 1. Validate everything first (nothing is modified yet) ----
    if (paymentRepository.getPaymentById(paymentId) != null) {
      throw const ValidationException('Payment ID already exists.');
    }

    final booking = bookingRepository.getBookingById(bookingId);

    if (booking == null) {
      throw const NotFoundException('Booking not found.');
    }

    if (booking.status != BookingStatus.confirmed) {
      throw const ValidationException('Only confirmed bookings can be paid.');
    }

    if (booking.paymentStatus == PaymentStatus.paid ||
        paymentRepository.getPaymentByBookingId(bookingId) != null) {
      throw const ValidationException('This booking has already been paid.');
    }

    if (paymentMethod.trim().isEmpty) {
      throw const ValidationException('Payment method cannot be empty.');
    }

    final customer = customerRepository.getCustomerById(
      booking.customer.customerId,
    );

    if (customer == null) {
      throw const NotFoundException('Customer not found.');
    }

    if (customer.accountBalance < booking.totalCost) {
      throw const ValidationException(
        'Insufficient account balance to pay for this booking.',
      );
    }

    final payment = PaymentRecord(
      paymentId: paymentId,
      booking: booking,
      amount: booking.totalCost,
      paymentDate: paymentDate,
      paymentMethod: paymentMethod,
    );

    // ---- 2. Apply the changes (all checks already passed) ----
    customer.deductBalance(booking.totalCost);
    customerRepository.updateCustomer(customer);

    booking.markAsPaid();
    bookingRepository.updateBooking(booking);

    paymentRepository.addPayment(payment);
  }
}
