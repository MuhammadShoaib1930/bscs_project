import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/settings/settings_event.dart';
import 'hive/hive_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveManager.initHive();

  runApp(
    BlocProvider<SettingsBloc>(
      create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
      child: MyApp(),
    ),
  );
}
