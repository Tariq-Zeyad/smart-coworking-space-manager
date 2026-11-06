import '../../core/errors/app_exceptions.dart';

import 'customer.dart';
import 'workspace.dart';

import '../enums/booking_status.dart';
import '../enums/payment_status.dart';

class Booking {
  final int bookingId;

  final Customer customer;
  final Workspace workspace;

  final DateTime bookingDate;
  final String startTime;

  final double durationHours;
  final double totalCost;

  BookingStatus status;
  PaymentStatus paymentStatus;

  Booking({
    required this.bookingId,
    required this.customer,
    required this.workspace,
    required this.bookingDate,
    required this.startTime,
    required this.durationHours,
    required this.status,
    required this.paymentStatus,
  }) : totalCost = workspace.hourlyRate * durationHours {
    if (bookingId <= 0) {
      throw const ValidationException('Booking ID must be positive');
    }

    if (!durationHours.isFinite || durationHours <= 0) {
      throw const ValidationException('Duration must be greater than zero');
    }

    if (startTime.trim().isEmpty) {
      throw const ValidationException('Start time cannot be empty');
    }

    if (totalCost <= 0 || !totalCost.isFinite) {
      throw const ValidationException('Invalid booking cost');
    }
  }

  /// Booking is "active" while it still occupies the workspace.
  bool get isActive =>
      status == BookingStatus.pending || status == BookingStatus.confirmed;

  DateTime get startDateTime {
    final parts = startTime.split(':');
    return DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  DateTime get endDateTime => startDateTime.add(
    Duration(
      microseconds: (durationHours * Duration.microsecondsPerHour).round(),
    ),
  );

  bool overlapsWith(Booking other) {
    return startDateTime.isBefore(other.endDateTime) &&
        other.startDateTime.isBefore(endDateTime);
  }

  void confirmBooking() {
    if (status != BookingStatus.pending) {
      throw const ValidationException('Only pending bookings can be confirmed');
    }

    status = BookingStatus.confirmed;
  }

  void cancelBooking() {
    if (status == BookingStatus.cancelled ||
        status == BookingStatus.completed) {
      throw const ValidationException('This booking cannot be cancelled.');
    }

    if (paymentStatus == PaymentStatus.paid) {
      throw const ValidationException(
        'A paid booking cannot be cancelled (no refund support).',
      );
    }

    status = BookingStatus.cancelled;
  }

  void completeBooking() {
    if (status != BookingStatus.confirmed) {
      throw const ValidationException(
        'Only confirmed bookings can be completed.',
      );
    }

    if (paymentStatus != PaymentStatus.paid) {
      throw const ValidationException(
        'The booking must be paid before it can be completed.',
      );
    }

    status = BookingStatus.completed;
  }

  void markAsPaid() {
    if (status != BookingStatus.confirmed) {
      throw const ValidationException('Only confirmed bookings can be paid');
    }

    if (paymentStatus == PaymentStatus.paid) {
      throw const ValidationException('This booking is already paid');
    }

    paymentStatus = PaymentStatus.paid;
  }
}
