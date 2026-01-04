import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:bscs_project/routes/app_routes.dart';
import 'package:bscs_project/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Your App',
          theme: AppTheme.lightTheme(state.fontFamily, state.fontSize),
          darkTheme: AppTheme.darkTheme(state.fontFamily, state.fontSize),
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
