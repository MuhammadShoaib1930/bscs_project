import 'package:flutter/material.dart';

class Helper {
  static TimeOfDay parseSafeTime(String value) {
    try {
      final parts = value.split(":");
      if (parts.length != 2) return const TimeOfDay(hour: 0, minute: 0);

      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;

      return TimeOfDay(hour: h, minute: m);
    } catch (_) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }
}
