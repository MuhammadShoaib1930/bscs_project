import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static const String settingsBox = 'settings_box';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBox);
  }

  static Box getSettingsBox() => Hive.box(settingsBox);
}
