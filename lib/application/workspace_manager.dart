import '../core/errors/app_exceptions.dart';

import '../data/data_sources/local/booking_local_data_source.dart';
import '../data/data_sources/local/customer_local_data_source.dart';
import '../data/data_sources/local/payment_local_data_source.dart';
import '../data/data_sources/local/workspace_local_data_source.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/repositories/customer_repository_impl.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../data/repositories/workspace_repository_impl.dart';

import '../domain/entities/booking.dart';
import '../domain/entities/customer.dart';
import '../domain/entities/payment_record.dart';
import '../domain/entities/workspace.dart';
import '../domain/enums/workspace_type.dart';
import '../domain/services/workspace_availability_service.dart';

import '../domain/use_cases/booking/cancel_booking.dart';
import '../domain/use_cases/booking/complete_booking.dart';
import '../domain/use_cases/booking/confirm_booking.dart';
import '../domain/use_cases/booking/create_booking.dart';
import '../domain/use_cases/booking/get_all_bookings.dart';
import '../domain/use_cases/booking/get_booking_by_id.dart';
import '../domain/use_cases/booking/get_bookings_by_customer.dart';
import '../domain/use_cases/customer/add_customer.dart';
import '../domain/use_cases/customer/add_customer_balance.dart';
import '../domain/use_cases/customer/get_all_customers.dart';
import '../domain/use_cases/customer/get_customer_by_id.dart';
import '../domain/use_cases/payment/get_all_payments.dart';
import '../domain/use_cases/payment/record_payment.dart';
import '../domain/use_cases/report/generate_report.dart';
import '../domain/use_cases/workspace/add_workspace.dart';
import '../domain/use_cases/workspace/delete_workspace.dart';
import '../domain/use_cases/workspace/get_all_workspaces.dart';
import '../domain/use_cases/workspace/get_available_workspaces.dart';
import '../domain/use_cases/workspace/get_workspace_by_id.dart';
import '../domain/use_cases/workspace/get_workspaces_by_type.dart';

/// Central manager: owns the repositories (Maps/Lists live in the data
/// sources) and exposes every operation the console UI needs.
class WorkspaceManager {
  late final CustomerRepositoryImpl _customers;
  late final WorkspaceRepositoryImpl _workspaces;
  late final BookingRepositoryImpl _bookings;
  late final PaymentRepositoryImpl _payments;
  late final WorkspaceAvailabilityService _availability;

  late final AddCustomer _addCustomer;
  late final GetCustomerById _getCustomerById;
  late final GetAllCustomers _getAllCustomers;
  late final AddCustomerBalance _addCustomerBalance;

  late final AddWorkspace _addWorkspace;
  late final DeleteWorkspace _deleteWorkspace;
  late final GetAllWorkspaces _getAllWorkspaces;
  late final GetWorkspaceById _getWorkspaceById;
  late final GetWorkspacesByType _getWorkspacesByType;
  late final GetAvailableWorkspaces _getAvailableWorkspaces;

  late final CreateBooking _createBooking;
  late final ConfirmBooking _confirmBooking;
  late final CancelBooking _cancelBooking;
  late final CompleteBooking _completeBooking;
  late final GetBookingById _getBookingById;
  late final GetAllBookings _getAllBookings;
  late final GetBookingsByCustomer _getBookingsByCustomer;

  late final RecordPayment _recordPayment;
  late final GetAllPayments _getAllPayments;
  late final GenerateReport _generateReport;

  WorkspaceManager() {
    _customers = CustomerRepositoryImpl(dataSource: CustomerLocalDataSource());
    _workspaces = WorkspaceRepositoryImpl(
      dataSource: WorkspaceLocalDataSource(),
    );
    _bookings = BookingRepositoryImpl(dataSource: BookingLocalDataSource());
    _payments = PaymentRepositoryImpl(dataSource: PaymentLocalDataSource());

    _availability = WorkspaceAvailabilityService(
      bookingRepository: _bookings,
      workspaceRepository: _workspaces,
    );

    _addCustomer = AddCustomer(_customers);
    _getCustomerById = GetCustomerById(_customers);
    _getAllCustomers = GetAllCustomers(_customers);
    _addCustomerBalance = AddCustomerBalance(_customers);

    _addWorkspace = AddWorkspace(_workspaces);
    _deleteWorkspace = DeleteWorkspace(_workspaces, _availability);
    _getAllWorkspaces = GetAllWorkspaces(_workspaces);
    _getWorkspaceById = GetWorkspaceById(_workspaces);
    _getWorkspacesByType = GetWorkspacesByType(_workspaces);
    _getAvailableWorkspaces = GetAvailableWorkspaces(_workspaces);

    _createBooking = CreateBooking(
      customerRepository: _customers,
      workspaceRepository: _workspaces,
      bookingRepository: _bookings,
      availabilityService: _availability,
    );
    _confirmBooking = ConfirmBooking(
      repository: _bookings,
      customerRepository: _customers,
      workspaceRepository: _workspaces,
      availabilityService: _availability,
    );
    _cancelBooking = CancelBooking(
      repository: _bookings,
      availabilityService: _availability,
    );
    _completeBooking = CompleteBooking(
      repository: _bookings,
      availabilityService: _availability,
    );
    _getBookingById = GetBookingById(_bookings);
    _getAllBookings = GetAllBookings(_bookings);
    _getBookingsByCustomer = GetBookingsByCustomer(_bookings);

    _recordPayment = RecordPayment(
      bookingRepository: _bookings,
      paymentRepository: _payments,
      customerRepository: _customers,
    );
    _getAllPayments = GetAllPayments(paymentRepository: _payments);
    _generateReport = GenerateReport(
      customerRepository: _customers,
      workspaceRepository: _workspaces,
      bookingRepository: _bookings,
      paymentRepository: _payments,
    );
  }

  // ------------------------- Customers -------------------------
  void registerCustomer({
    required int id,
    required String name,
    required String phone,
    double balance = 0,
  }) {
    _addCustomer.execute(
      Customer(
        customerId: id,
        fullName: name,
        phoneNumber: phone,
        accountBalance: balance,
      ),
    );
  }

  Customer? findCustomer(int id) => _getCustomerById.execute(id);

  List<Customer> get customers => _getAllCustomers.execute();

  void addCustomerBalance(int customerId, double amount) =>
      _addCustomerBalance.execute(customerId, amount);

  // ------------------------- Workspaces -------------------------
  void addWorkspace({
    required int id,
    required String name,
    required WorkspaceType type,
    required double hourlyRate,
  }) {
    _addWorkspace.execute(
      Workspace(
        workspaceId: id,
        name: name,
        type: type,
        hourlyRate: hourlyRate,
      ),
    );
  }

  void removeWorkspace(int id) => _deleteWorkspace.execute(id);

  List<Workspace> get workspaces => _getAllWorkspaces.execute();

  Workspace? findWorkspace(int id) => _getWorkspaceById.execute(id);

  List<Workspace> workspacesByType(WorkspaceType type) =>
      _getWorkspacesByType.execute(type);

  List<Workspace> get availableWorkspaces => _getAvailableWorkspaces.execute();

  // ------------------------- Bookings -------------------------
  /// Creates a booking and returns its auto-generated ID.
  int createBooking({
    required int customerId,
    required int workspaceId,
    required DateTime date,
    required String startTime,
    required double durationHours,
  }) {
    final id = _nextBookingId();
    _createBooking.execute(
      bookingId: id,
      customerId: customerId,
      workspaceId: workspaceId,
      bookingDate: date,
      startTime: startTime,
      durationHours: durationHours,
    );
    return id;
  }

  Booking? findBooking(int id) => _getBookingById.execute(id);

  List<Booking> get bookings => _getAllBookings.execute();

  List<Booking> bookingsOfCustomer(int customerId) =>
      _getBookingsByCustomer.execute(customerId);

  /// Asynchronous: waits for the availability check before confirming.
  Future<void> confirmBooking(int id) => _confirmBooking.execute(id);

  void cancelBooking(int id) => _cancelBooking.execute(id);

  void completeBooking(int id) => _completeBooking.execute(id);

  // ------------------------- Payments -------------------------
  /// Pays for a booking from the customer's balance and returns the
  /// payment ID.
  int processPayment(int bookingId, {String method = 'Account Balance'}) {
    final id = _nextPaymentId();
    _recordPayment.execute(
      paymentId: id,
      bookingId: bookingId,
      paymentMethod: method,
      paymentDate: DateTime.now(),
    );
    return id;
  }

  List<PaymentRecord> get payments => _getAllPayments.execute();

  // ------------------------- Reports -------------------------
  SystemReport buildReport() => _generateReport.execute();

  // ------------------------- Helpers -------------------------
  int _nextBookingId() {
    final ids = _bookings.getAllBookings().map((b) => b.bookingId);
    return ids.isEmpty ? 1 : ids.reduce((a, b) => a > b ? a : b) + 1;
  }

  int _nextPaymentId() {
    final ids = _payments.getAllPayments().map((p) => p.paymentId);
    return ids.isEmpty ? 1 : ids.reduce((a, b) => a > b ? a : b) + 1;
  }
}

/// Re-exported so callers can catch the app's errors with one import.
typedef ManagerException = AppException;
