// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class SettingsModel extends HiveObject {
  @HiveField(0)
  double fontSize;

  @HiveField(1)
  String fontFamily;

  @HiveField(2)
  bool isDarkMode;

  @HiveField(3)
  bool isOnline;

  SettingsModel({
    required this.fontSize,
    required this.fontFamily,
    required this.isDarkMode,
    required this.isOnline,
  });

  SettingsModel copyWith({
    double? fontSize,
    String? fontFamily,
    bool? isDarkMode,
    bool? isOnline,
  }) {
    return SettingsModel(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
