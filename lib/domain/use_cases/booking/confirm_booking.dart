import '../../enums/booking_status.dart';
import '../../repositories/booking_repository.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/workspace_repository.dart';
import '../../services/workspace_availability_service.dart';
import '../../../core/errors/app_exceptions.dart';

class ConfirmBooking {
  final BookingRepository repository;
  final CustomerRepository customerRepository;
  final WorkspaceRepository workspaceRepository;
  final WorkspaceAvailabilityService availabilityService;

  ConfirmBooking({
    required this.repository,
    required this.customerRepository,
    required this.workspaceRepository,
    required this.availabilityService,
  });

  /// Asynchronously checks the booking conditions (simulated 2 second delay)
  /// and confirms the booking only if all of them are satisfied.
  Future<void> execute(int bookingId) async {
    // Simulates a remote availability check.
    await Future.delayed(const Duration(seconds: 2));

    final booking = repository.getBookingById(bookingId);

    if (booking == null) {
      throw const NotFoundException('Booking not found.');
    }

    if (booking.status != BookingStatus.pending) {
      throw const ValidationException('Only pending bookings can be confirmed');
    }

    if (customerRepository.getCustomerById(booking.customer.customerId) ==
        null) {
      throw const NotFoundException('Customer no longer exists.');
    }

    if (workspaceRepository.getWorkspaceById(booking.workspace.workspaceId) ==
        null) {
      throw const NotFoundException('Workspace no longer exists.');
    }

    final conflicts = repository
        .getBookingsByWorkspace(booking.workspace.workspaceId)
        .where(
          (other) =>
              other.bookingId != booking.bookingId &&
              other.status == BookingStatus.confirmed &&
              other.overlapsWith(booking),
        );

    if (conflicts.isNotEmpty) {
      throw const ValidationException(
        'Workspace is not available: it overlaps a confirmed booking',
      );
    }

    booking.confirmBooking();
    repository.updateBooking(booking);
    availabilityService.refresh(booking.workspace.workspaceId);
  }
}
