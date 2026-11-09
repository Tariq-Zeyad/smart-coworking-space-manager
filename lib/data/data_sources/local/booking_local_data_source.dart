import '../../../domain/entities/booking.dart';

class BookingLocalDataSource {
  final Map<int, Booking> _bookings = {};

  void addBooking(Booking booking) {
    _bookings[booking.bookingId] = booking;
  }

  Booking? getBookingById(int bookingId) {
    return _bookings[bookingId];
  }

  List<Booking> getAllBookings() {
    return _bookings.values.toList();
  }

  List<Booking> getBookingsByCustomer(int customerId) {
    return _bookings.values
        .where((booking) => booking.customer.customerId == customerId)
        .toList();
  }

  List<Booking> getBookingsByWorkspace(int workspaceId) {
    return _bookings.values
        .where((booking) => booking.workspace.workspaceId == workspaceId)
        .toList();
  }

  void updateBooking(Booking booking) {
    if (_bookings.containsKey(booking.bookingId)) {
      _bookings[booking.bookingId] = booking;
    }
  }

  void deleteBooking(int bookingId) {
    _bookings.remove(bookingId);
  }
}
