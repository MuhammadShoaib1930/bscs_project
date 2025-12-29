import 'package:bscs_project/core/route_names.dart';
import 'package:bscs_project/core/routes_generates.dart';
import 'package:bscs_project/screens/bottom_slider_pages/bloc/bottom_slider_page_bloc.dart';
import 'package:bscs_project/screens/bottom_slider_pages/bottom_slider_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RoutesNames.splashPage,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: BlocProvider(create: (context) => BottomSliderPageBloc(), child: const BottomSliderPages()),
    );
  }
}
