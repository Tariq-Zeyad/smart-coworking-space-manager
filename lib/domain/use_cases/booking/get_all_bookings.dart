import '../../entities/booking.dart';
import '../../../data/repositories/booking_repository_impl.dart';

class GetAllBookings {
  final BookingRepositoryImpl repository;

  GetAllBookings(this.repository);

  List<Booking> execute() {
    return repository.getAllBookings();
  }
}
