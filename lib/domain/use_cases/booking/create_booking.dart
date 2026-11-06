import '../../entities/booking.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/workspace_repository.dart';
import '../../repositories/booking_repository.dart';
import '../../services/workspace_availability_service.dart';

import '../../enums/booking_status.dart';
import '../../enums/payment_status.dart';

import '../../../core/errors/app_exceptions.dart';

class CreateBooking {
  final CustomerRepository customerRepository;
  final WorkspaceRepository workspaceRepository;
  final BookingRepository bookingRepository;
  final WorkspaceAvailabilityService availabilityService;

  CreateBooking({
    required this.customerRepository,
    required this.workspaceRepository,
    required this.bookingRepository,
    required this.availabilityService,
  });

  void execute({
    required int bookingId,
    required int customerId,
    required int workspaceId,
    required DateTime bookingDate,
    required String startTime,
    required double durationHours,
  }) {
    if (bookingId <= 0) {
      throw const ValidationException('Booking ID must be positive');
    }

    if (bookingRepository.getBookingById(bookingId) != null) {
      throw const ValidationException('Booking ID already exists');
    }

    final customer = customerRepository.getCustomerById(customerId);

    if (customer == null) {
      throw const NotFoundException('Customer not found');
    }

    final workspace = workspaceRepository.getWorkspaceById(workspaceId);

    if (workspace == null) {
      throw const NotFoundException('Workspace not found');
    }

    if (!durationHours.isFinite || durationHours <= 0) {
      throw const ValidationException('Duration must be greater than zero');
    }

    if (durationHours > 24) {
      throw const ValidationException('Duration cannot exceed 24 hours');
    }

    final normalizedTime = normalizeStartTime(startTime);

    final booking = Booking(
      bookingId: bookingId,
      customer: customer,
      workspace: workspace,
      bookingDate: bookingDate,
      startTime: normalizedTime,
      durationHours: durationHours,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.unpaid,
    );

    final existingBookings = bookingRepository.getBookingsByWorkspace(
      workspaceId,
    );

    for (final existing in existingBookings) {
      if (existing.isActive && existing.overlapsWith(booking)) {
        throw const ValidationException(
          'Workspace is already booked during this time',
        );
      }
    }

    bookingRepository.addBooking(booking);
    availabilityService.refresh(workspaceId);
  }

  /// Validates "HH:mm" and returns it zero-padded (e.g. 9:5 -> 09:05).
  static String normalizeStartTime(String startTime) {
    final parts = startTime.trim().split(':');

    if (parts.length != 2) {
      throw const ValidationException('Start time must use HH:mm format');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw const ValidationException('Invalid start time');
    }

    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }
}
