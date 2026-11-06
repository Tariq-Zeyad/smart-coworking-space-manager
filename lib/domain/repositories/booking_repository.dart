import '../entities/booking.dart';

abstract class BookingRepository {
  void addBooking(Booking booking);

  Booking? getBookingById(int bookingId);

  List<Booking> getAllBookings();

  List<Booking> getBookingsByCustomer(int customerId);

  List<Booking> getBookingsByWorkspace(int workspaceId);

  void updateBooking(Booking booking);

  void deleteBooking(int bookingId);
}
