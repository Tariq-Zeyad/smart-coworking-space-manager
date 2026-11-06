import '../../repositories/booking_repository.dart';
import '../../services/workspace_availability_service.dart';
import '../../../core/errors/app_exceptions.dart';

class CancelBooking {
  final BookingRepository repository;
  final WorkspaceAvailabilityService availabilityService;

  CancelBooking({required this.repository, required this.availabilityService});

  void execute(int bookingId) {
    final booking = repository.getBookingById(bookingId);

    if (booking == null) {
      throw const NotFoundException('Booking not found.');
    }

    booking.cancelBooking();

    repository.updateBooking(booking);

    // Re-evaluate availability from the remaining bookings.
    availabilityService.refresh(booking.workspace.workspaceId);
  }
}
