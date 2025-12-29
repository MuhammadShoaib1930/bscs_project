import 'package:bscs_project/app.dart';
import 'package:bscs_project/core/route_names.dart';
import 'package:bscs_project/screens/splash_page/splash_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.splashPage:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case RoutesNames.home:
        return MaterialPageRoute(builder: (_) => App());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
