import 'dart:io';

/// Thrown when stdin is closed (Ctrl+D / end of piped input).
class InputClosedException implements Exception {
  const InputClosedException();
}

/// Small helpers that keep asking until the user types a valid value,
/// so bad input never crashes the program.
class ConsoleIO {
  String readLine(String prompt) {
    stdout.write(prompt);
    final line = stdin.readLineSync();
    if (line == null) throw const InputClosedException();
    return line.trim();
  }

  String readNonEmpty(String prompt, String fieldName) {
    while (true) {
      final value = readLine(prompt);
      if (value.isNotEmpty) return value;
      print('  ! $fieldName cannot be empty. Try again.');
    }
  }

  int readPositiveInt(String prompt, String fieldName) {
    while (true) {
      final value = int.tryParse(readLine(prompt));
      if (value != null && value > 0) return value;
      print('  ! $fieldName must be a positive whole number. Try again.');
    }
  }

  double readPositiveDouble(String prompt, String fieldName) {
    while (true) {
      final value = double.tryParse(readLine(prompt));
      if (value != null && value.isFinite && value > 0) return value;
      print('  ! $fieldName must be a number greater than zero. Try again.');
    }
  }

  /// Like [readPositiveDouble] but allows zero (e.g. initial balance).
  double readNonNegativeDouble(String prompt, String fieldName) {
    while (true) {
      final value = double.tryParse(readLine(prompt));
      if (value != null && value.isFinite && value >= 0) return value;
      print('  ! $fieldName cannot be negative or invalid. Try again.');
    }
  }

  /// Reads a date as yyyy-MM-dd. Empty input means today.
  DateTime readDate(String prompt) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    while (true) {
      final text = readLine(prompt);
      if (text.isEmpty) return todayOnly;

      final match = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
      if (match != null) {
        final y = int.parse(match.group(1)!);
        final m = int.parse(match.group(2)!);
        final d = int.parse(match.group(3)!);
        final date = DateTime(y, m, d);

        // DateTime rolls invalid dates over (e.g. 2026-02-31), so verify.
        if (date.year == y && date.month == m && date.day == d) {
          if (date.isBefore(todayOnly)) {
            print('  ! The date cannot be in the past.');
            continue;
          }
          return date;
        }
      }
      print('  ! Invalid date. Use yyyy-MM-dd (or press Enter for today).');
    }
  }
}
