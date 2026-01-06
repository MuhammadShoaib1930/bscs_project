import 'package:bscs_project/ui/gas/bloc/gas_bloc.dart';
import 'package:bscs_project/ui/relays/bloc/relays_bloc.dart';
import 'package:bscs_project/ui/servo/bloc/servo_bloc.dart';
import 'package:bscs_project/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ui/home/home_page.dart';
import '../ui/relays/relays_page.dart';
import '../ui/servo/servo_page.dart';
import '../ui/gas/gas_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
  static const String relays = '/relays';
  static const String servo = '/servo';
  static const String gas = '/gas';
  static const String splash = '/splash';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomePage(),
    splash: (_) => const SplashScreen(),
    relays: (_) => BlocProvider(create: (context) => RelaysBloc(), child: const RelaysPage()),
    servo: (_) => BlocProvider(create: (context) => ServoBloc(), child: const ServoPage()),
    gas: (_) => BlocProvider(create: (context) => GasBloc(), child: const GasPage()),
  };
}
