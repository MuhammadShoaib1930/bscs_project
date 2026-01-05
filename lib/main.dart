import 'package:bscs_project/constants/app_constants.dart';
import 'package:bscs_project/hive/settings_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/settings/settings_event.dart';
import 'hive/hive_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(SettingsModelAdapter());
  await Firebase.initializeApp();
  await HiveManager.initHive();
  await Hive.openBox<SettingsModel>(AppConstants.settingModel);

  runApp(
    BlocProvider<SettingsBloc>(
      create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
      child: MyApp(),
    ),
  );
}
