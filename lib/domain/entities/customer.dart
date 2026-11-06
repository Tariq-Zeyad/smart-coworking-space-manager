import '../../core/errors/app_exceptions.dart';

class Customer {
  final int customerId;
  final String fullName;
  final String phoneNumber;

  double _accountBalance;

  Customer({
    required this.customerId,
    required String fullName,
    required String phoneNumber,
    double accountBalance = 0,
  }) : fullName = fullName.trim(),
       phoneNumber = phoneNumber.trim(),
       _accountBalance = accountBalance {
    if (customerId <= 0) {
      throw const ValidationException('Customer ID must be positive');
    }

    if (this.fullName.isEmpty) {
      throw const ValidationException('Customer name cannot be empty');
    }

    if (this.phoneNumber.isEmpty) {
      throw const ValidationException('Phone number cannot be empty');
    }

    if (!accountBalance.isFinite || accountBalance < 0) {
      throw const ValidationException('Invalid account balance');
    }
  }

  double get accountBalance => _accountBalance;

  void addBalance(double amount) {
    if (!amount.isFinite || amount <= 0) {
      throw const ValidationException('Amount must be greater than zero');
    }

    _accountBalance += amount;
  }

  void deductBalance(double amount) {
    if (!amount.isFinite || amount <= 0) {
      throw const ValidationException('Amount must be greater than zero');
    }

    if (amount > _accountBalance) {
      throw const ValidationException('Insufficient account balance');
    }

    _accountBalance -= amount;
  }
}
