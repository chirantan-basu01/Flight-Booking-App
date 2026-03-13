import 'package:flutter/material.dart';

extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Returns true if the string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Returns the string with only digits
  String get digitsOnly {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}

extension ContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  /// Pop with result
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}

extension DoubleExtensions on double {
  /// Format as currency
  String toCurrency({String symbol = '\$', int decimals = 0}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }
}

extension IntExtensions on int {
  /// Format as currency
  String toCurrency({String symbol = '\$'}) {
    return '$symbol$this';
  }

  /// Get stops text
  String get stopsText {
    if (this == 0) return 'Direct';
    if (this == 1) return '1 stop';
    return '$this stops';
  }
}

extension ListExtensions<T> on List<T> {
  /// Returns the first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}

extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisDate = DateTime(year, month, day);
    return thisDate.isBefore(today);
  }

  /// Get date only (without time)
  DateTime get dateOnly => DateTime(year, month, day);
}