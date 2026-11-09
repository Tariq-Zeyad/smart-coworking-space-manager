import '../../entities/booking.dart';
import '../../../data/repositories/booking_repository_impl.dart';

class GetBookingsByCustomer {
  final BookingRepositoryImpl repository;

  GetBookingsByCustomer(this.repository);

  List<Booking> execute(int customerId) {
    return repository.getBookingsByCustomer(customerId);
  }
}
