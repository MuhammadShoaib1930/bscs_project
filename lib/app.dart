import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:bscs_project/constants/app_constants.dart';
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
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(state.settingsModel.fontFamily, state.settingsModel.fontSize),
          darkTheme: AppTheme.darkTheme(state.settingsModel.fontFamily, state.settingsModel.fontSize),
          themeMode: state.settingsModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
