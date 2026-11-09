import '../../entities/booking.dart';
import '../../../data/repositories/booking_repository_impl.dart';

class GetBookingById {
  final BookingRepositoryImpl repository;

  GetBookingById(this.repository);

  Booking? execute(int bookingId) {
    return repository.getBookingById(bookingId);
  }
}
