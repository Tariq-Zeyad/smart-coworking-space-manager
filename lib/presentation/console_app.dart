import '../application/workspace_manager.dart';
import '../core/errors/app_exceptions.dart';
import '../domain/entities/booking.dart';
import '../domain/entities/customer.dart';
import '../domain/entities/workspace.dart';
import '../domain/enums/payment_status.dart';
import '../domain/enums/workspace_type.dart';
import 'console_io.dart';

class ConsoleApp {
  final WorkspaceManager manager;
  final ConsoleIO io;

  ConsoleApp({WorkspaceManager? manager, ConsoleIO? io})
    : manager = manager ?? WorkspaceManager(),
      io = io ?? ConsoleIO();

  Future<void> run() async {
    print('=== Smart Co-Working Space Management System ===');

    try {
      while (true) {
        _printMenu();
        final choice = io.readLine('Enter your choice: ');

        if (choice == '0') {
          print('Goodbye!');
          return;
        }

        try {
          await _handle(choice);
        } on AppException catch (e) {
          print('  Error: ${e.message}');
        } on InputClosedException {
          rethrow;
        } on FormatException catch (e) {
          print('  Invalid input: ${e.message}');
        } catch (e) {
          // Safety net: the program must never crash on bad data.
          print('  Unexpected error: $e');
        }
      }
    } on InputClosedException {
      print('\nInput closed. Exiting.');
    }
  }

  void _printMenu() {
    print('''

------------------ MENU ------------------
 1. Register Customer
 2. Add Workspace
 3. Remove Workspace
 4. Display Workspaces
 5. Search Workspace
 6. Display Workspaces by Type
 7. Add Customer Balance
 8. Create Booking
 9. Search Booking
10. Display All Bookings
11. Cancel Booking
12. Confirm Booking
13. Complete Booking
14. Process Payment
15. Display Reports
16. Search Customer
17. Display All Customers
18. Display Available Workspaces
19. Display Customer Bookings
20. Display Unpaid Bookings
 0. Exit
------------------------------------------''');
  }

  Future<void> _handle(String choice) async {
    switch (choice) {
      case '1':
        _registerCustomer();
      case '2':
        _addWorkspace();
      case '3':
        _removeWorkspace();
      case '4':
        _printWorkspaces(manager.workspaces);
      case '5':
        _searchWorkspace();
      case '6':
        _displayByType();
      case '7':
        _addBalance();
      case '8':
        _createBooking();
      case '9':
        _searchBooking();
      case '10':
        _printBookings(manager.bookings);
      case '11':
        _cancelBooking();
      case '12':
        await _confirmBooking();
      case '13':
        _completeBooking();
      case '14':
        _processPayment();
      case '15':
        _displayReports();
      case '16':
        _searchCustomer();
      case '17':
        _printCustomers(manager.customers);
      case '18':
        _printWorkspaces(manager.availableWorkspaces);
      case '19':
        _customerBookings();
      case '20':
        _printBookings(manager.buildReport().unpaidBookings);
      default:
        print('  Invalid choice. Please enter a number from the menu.');
    }
  }

  // ---------------------------- Customers ----------------------------
  void _registerCustomer() {
    final id = io.readPositiveInt('Customer ID: ', 'Customer ID');
    if (manager.findCustomer(id) != null) {
      throw const ValidationException('Customer ID already exists.');
    }
    final name = io.readNonEmpty('Full name: ', 'Name');
    final phone = io.readNonEmpty('Phone number: ', 'Phone number');
    final balance = io.readNonNegativeDouble(
      'Initial balance (0 for none): ',
      'Balance',
    );

    manager.registerCustomer(
      id: id,
      name: name,
      phone: phone,
      balance: balance,
    );
    print('  Customer registered successfully.');
  }

  void _searchCustomer() {
    final id = io.readPositiveInt('Customer ID: ', 'Customer ID');
    final customer = manager.findCustomer(id);
    if (customer == null) {
      print('  Customer not found.');
    } else {
      _printCustomers([customer]);
    }
  }

  void _addBalance() {
    final id = io.readPositiveInt('Customer ID: ', 'Customer ID');
    final customer = manager.findCustomer(id);
    if (customer == null) {
      throw const NotFoundException('Customer not found.');
    }
    final amount = io.readPositiveDouble('Amount to add: ', 'Amount');
    manager.addCustomerBalance(id, amount);
    print(
      '  Balance updated. New balance: '
      '${_money(manager.findCustomer(id)!.accountBalance)}',
    );
  }

  // --------------------------- Workspaces ---------------------------
  void _addWorkspace() {
    final id = io.readPositiveInt('Workspace ID: ', 'Workspace ID');
    if (manager.findWorkspace(id) != null) {
      throw const ValidationException('Workspace ID already exists.');
    }
    final name = io.readNonEmpty('Workspace name: ', 'Name');
    final type = _readType();
    final rate = io.readPositiveDouble('Hourly rate: ', 'Hourly rate');

    manager.addWorkspace(id: id, name: name, type: type, hourlyRate: rate);
    print('  Workspace added successfully.');
  }

  void _removeWorkspace() {
    final id = io.readPositiveInt('Workspace ID: ', 'Workspace ID');
    manager.removeWorkspace(id);
    print('  Workspace removed.');
  }

  void _searchWorkspace() {
    final id = io.readPositiveInt('Workspace ID: ', 'Workspace ID');
    final workspace = manager.findWorkspace(id);
    if (workspace == null) {
      print('  Workspace not found.');
    } else {
      _printWorkspaces([workspace]);
    }
  }

  void _displayByType() {
    _printWorkspaces(manager.workspacesByType(_readType()));
  }

  WorkspaceType _readType() {
    while (true) {
      final choice = io.readLine(
        'Type (1 = Desk, 2 = Private Office, 3 = Meeting Room): ',
      );
      switch (choice) {
        case '1':
          return WorkspaceType.desk;
        case '2':
          return WorkspaceType.privateOffice;
        case '3':
          return WorkspaceType.meetingRoom;
      }
      print('  ! Please enter 1, 2 or 3.');
    }
  }

  // ----------------------------- Bookings -----------------------------
  void _createBooking() {
    final customerId = io.readPositiveInt('Customer ID: ', 'Customer ID');
    if (manager.findCustomer(customerId) == null) {
      throw const NotFoundException('Customer not found.');
    }
    final workspaceId = io.readPositiveInt('Workspace ID: ', 'Workspace ID');
    if (manager.findWorkspace(workspaceId) == null) {
      throw const NotFoundException('Workspace not found.');
    }
    final date = io.readDate('Date (yyyy-MM-dd, Enter = today): ');
    final start = io.readNonEmpty('Start time (HH:mm): ', 'Start time');
    final duration = io.readPositiveDouble('Duration in hours: ', 'Duration');

    final id = manager.createBooking(
      customerId: customerId,
      workspaceId: workspaceId,
      date: date,
      startTime: start,
      durationHours: duration,
    );
    final booking = manager.findBooking(id)!;
    print(
      '  Booking #$id created (Pending). '
      'Total cost: ${_money(booking.totalCost)}',
    );
  }

  void _searchBooking() {
    final id = io.readPositiveInt('Booking ID: ', 'Booking ID');
    final booking = manager.findBooking(id);
    if (booking == null) {
      print('  Booking not found.');
    } else {
      _printBookings([booking]);
    }
  }

  void _customerBookings() {
    final id = io.readPositiveInt('Customer ID: ', 'Customer ID');
    if (manager.findCustomer(id) == null) {
      throw const NotFoundException('Customer not found.');
    }
    _printBookings(manager.bookingsOfCustomer(id));
  }

  void _cancelBooking() {
    final id = io.readPositiveInt('Booking ID: ', 'Booking ID');
    manager.cancelBooking(id);
    print('  Booking #$id cancelled. Workspace availability updated.');
  }

  Future<void> _confirmBooking() async {
    final id = io.readPositiveInt('Booking ID: ', 'Booking ID');
    if (manager.findBooking(id) == null) {
      throw const NotFoundException('Booking not found.');
    }
    print('  Checking workspace availability...');
    await manager.confirmBooking(id);
    print('  Workspace is available. Booking #$id confirmed.');
  }

  void _completeBooking() {
    final id = io.readPositiveInt('Booking ID: ', 'Booking ID');
    manager.completeBooking(id);
    print('  Booking #$id completed.');
  }

  // ----------------------------- Payments -----------------------------
  void _processPayment() {
    final bookingId = io.readPositiveInt('Booking ID: ', 'Booking ID');
    final paymentId = manager.processPayment(bookingId);
    final booking = manager.findBooking(bookingId)!;
    print(
      '  Payment #$paymentId successful. Paid ${_money(booking.totalCost)}. '
      'Remaining balance: ${_money(booking.customer.accountBalance)}',
    );
  }

  // ------------------------------ Reports ------------------------------
  void _displayReports() {
    final r = manager.buildReport();

    print('\n========== REPORTS ==========');
    print('Total customers      : ${r.totalCustomers}');
    print('Workspaces by type:');
    r.workspacesByType.forEach((type, count) {
      print('   - ${_typeName(type).padRight(14)}: $count');
    });
    print('Total bookings       : ${r.totalBookings}');

    if (r.totalBookings == 0) {
      print('  (No bookings have been created yet.)');
    } else {
      print('   Pending           : ${r.pendingBookings}');
      print('   Confirmed         : ${r.confirmedBookings}');
      print('   Cancelled         : ${r.cancelledBookings}');
      print('   Completed         : ${r.completedBookings}');
    }

    print('Total revenue        : ${_money(r.totalRevenue)}');

    final top = r.mostBookedWorkspace;
    if (top == null) {
      print('Most booked workspace: N/A (no bookings)');
    } else {
      print(
        'Most booked workspace: ${top.name} (ID ${top.workspaceId}) '
        'with ${r.mostBookedCount} booking(s)',
      );
    }

    print('\nUnpaid bookings:');
    _printBookings(r.unpaidBookings);
  }

  // ------------------------------ Printing ------------------------------
  void _printCustomers(List<Customer> list) {
    if (list.isEmpty) {
      print('  No customers found.');
      return;
    }
    for (final c in list) {
      print(
        '  [${c.customerId}] ${c.fullName} | ${c.phoneNumber} | '
        'Balance: ${_money(c.accountBalance)}',
      );
    }
  }

  void _printWorkspaces(List<Workspace> list) {
    if (list.isEmpty) {
      print('  No workspaces found.');
      return;
    }
    for (final w in list) {
      print(
        '  [${w.workspaceId}] ${w.name} | ${_typeName(w.type)} | '
        '${_money(w.hourlyRate)}/h | '
        '${w.isAvailable ? 'Available' : 'Unavailable'}',
      );
    }
  }

  void _printBookings(List<Booking> list) {
    if (list.isEmpty) {
      print('  No bookings found.');
      return;
    }
    for (final b in list) {
      print(
        '  Booking #${b.bookingId} | Customer: ${b.customer.fullName} '
        '(${b.customer.customerId}) | Workspace: ${b.workspace.name} '
        '(${b.workspace.workspaceId})\n'
        '      Date: ${_date(b.bookingDate)} | Start: ${b.startTime} | '
        'Duration: ${b.durationHours}h | Cost: ${_money(b.totalCost)}\n'
        '      Status: ${b.status.name} | '
        'Payment: ${b.paymentStatus == PaymentStatus.paid ? 'paid' : 'unpaid'}',
      );
    }
  }

  String _money(double v) => v.toStringAsFixed(2);

  String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String _typeName(WorkspaceType t) {
    switch (t) {
      case WorkspaceType.desk:
        return 'Desk';
      case WorkspaceType.privateOffice:
        return 'Private Office';
      case WorkspaceType.meetingRoom:
        return 'Meeting Room';
    }
  }
}
