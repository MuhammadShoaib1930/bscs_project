import 'package:flutter/material.dart';
import '../ui/home/home_page.dart';
import '../ui/settings/settings_page.dart';
import '../ui/relays/relays_page.dart';
import '../ui/servo/servo_page.dart';
import '../ui/gas/gas_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
  static const String relays = '/relays';
  static const String servo = '/servo';
  static const String gas = '/gas';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomePage(),
    settings: (_) => SettingsPage(),
    relays: (_) => const RelaysPage(),
    servo: (_) => const ServoPage(),
    gas: (_) => const GasPage(),
  };
}
