import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../data_sources/local/booking_local_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource dataSource;

  BookingRepositoryImpl({required this.dataSource});

  @override
  void addBooking(Booking booking) {
    dataSource.addBooking(booking);
  }

  @override
  Booking? getBookingById(int bookingId) {
    return dataSource.getBookingById(bookingId);
  }

  @override
  List<Booking> getAllBookings() {
    return dataSource.getAllBookings();
  }

  @override
  List<Booking> getBookingsByCustomer(int customerId) {
    return dataSource.getBookingsByCustomer(customerId);
  }

  @override
  List<Booking> getBookingsByWorkspace(int workspaceId) {
    return dataSource.getBookingsByWorkspace(workspaceId);
  }

  @override
  void updateBooking(Booking booking) {
    dataSource.updateBooking(booking);
  }

  @override
  void deleteBooking(int bookingId) {
    dataSource.deleteBooking(bookingId);
  }
}
