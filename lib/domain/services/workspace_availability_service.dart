import '../repositories/booking_repository.dart';
import '../repositories/workspace_repository.dart';

/// Keeps `Workspace.isAvailable` consistent with its remaining bookings.
/// A workspace is unavailable while it has at least one active
/// (pending or confirmed) booking.
class WorkspaceAvailabilityService {
  final BookingRepository bookingRepository;
  final WorkspaceRepository workspaceRepository;

  WorkspaceAvailabilityService({
    required this.bookingRepository,
    required this.workspaceRepository,
  });

  bool hasActiveBookings(int workspaceId) {
    return bookingRepository
        .getBookingsByWorkspace(workspaceId)
        .any((booking) => booking.isActive);
  }

  void refresh(int workspaceId) {
    final workspace = workspaceRepository.getWorkspaceById(workspaceId);
    if (workspace == null) return;

    if (hasActiveBookings(workspaceId)) {
      workspace.markAsUnavailable();
    } else {
      workspace.markAsAvailable();
    }

    workspaceRepository.updateWorkspace(workspace);
  }
}
