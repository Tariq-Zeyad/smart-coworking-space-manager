import '../../entities/booking.dart';
import '../../entities/workspace.dart';
import '../../enums/booking_status.dart';
import '../../enums/payment_status.dart';
import '../../enums/workspace_type.dart';
import '../../repositories/booking_repository.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/payment_repository.dart';
import '../../repositories/workspace_repository.dart';

class SystemReport {
  final int totalCustomers;
  final Map<WorkspaceType, int> workspacesByType;
  final int totalBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int cancelledBookings;
  final int completedBookings;
  final double totalRevenue;
  final Workspace? mostBookedWorkspace;
  final int mostBookedCount;
  final List<Booking> unpaidBookings;

  SystemReport({
    required this.totalCustomers,
    required this.workspacesByType,
    required this.totalBookings,
    required this.pendingBookings,
    required this.confirmedBookings,
    required this.cancelledBookings,
    required this.completedBookings,
    required this.totalRevenue,
    required this.mostBookedWorkspace,
    required this.mostBookedCount,
    required this.unpaidBookings,
  });
}

class GenerateReport {
  final CustomerRepository customerRepository;
  final WorkspaceRepository workspaceRepository;
  final BookingRepository bookingRepository;
  final PaymentRepository paymentRepository;

  GenerateReport({
    required this.customerRepository,
    required this.workspaceRepository,
    required this.bookingRepository,
    required this.paymentRepository,
  });

  SystemReport execute() {
    final bookings = bookingRepository.getAllBookings();

    int countStatus(BookingStatus status) =>
        bookings.where((b) => b.status == status).length;

    final byType = <WorkspaceType, int>{
      for (final type in WorkspaceType.values)
        type: workspaceRepository.getWorkspacesByType(type).length,
    };

    // Count bookings per workspace (cancelled bookings are not counted).
    // The Workspace object is taken from the booking itself, so the report
    // still works if a workspace was removed after being booked.
    final counts = <int, int>{};
    final known = <int, Workspace>{};
    for (final booking in bookings) {
      if (booking.status == BookingStatus.cancelled) continue;
      final id = booking.workspace.workspaceId;
      counts[id] = (counts[id] ?? 0) + 1;
      known[id] = booking.workspace;
    }

    Workspace? mostBooked;
    int mostCount = 0;
    counts.forEach((id, count) {
      if (count > mostCount) {
        mostCount = count;
        mostBooked = known[id];
      }
    });

    final revenue = paymentRepository.getAllPayments().fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    final unpaid = bookings
        .where(
          (b) =>
              b.paymentStatus == PaymentStatus.unpaid &&
              b.status != BookingStatus.cancelled,
        )
        .toList();

    return SystemReport(
      totalCustomers: customerRepository.getAllCustomers().length,
      workspacesByType: byType,
      totalBookings: bookings.length,
      pendingBookings: countStatus(BookingStatus.pending),
      confirmedBookings: countStatus(BookingStatus.confirmed),
      cancelledBookings: countStatus(BookingStatus.cancelled),
      completedBookings: countStatus(BookingStatus.completed),
      totalRevenue: revenue,
      mostBookedWorkspace: mostBooked,
      mostBookedCount: mostCount,
      unpaidBookings: unpaid,
    );
  }
}
